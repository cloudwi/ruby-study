import { Controller } from "@hotwired/stimulus"

// Formats <time data-utc="ISO8601"> into the client local time and
// sets a persistent `timezone` cookie for server-side rendering on next requests.
export default class extends Controller {
  static targets = ["time"]
  static values = {
    format: { type: String, default: "yyyy-MM-dd HH:mm" },
  }

  connect() {
    this.ensureTimezoneCookie()
    this.formatTimes()
  }

  ensureTimezoneCookie() {
    try {
      const tz = Intl.DateTimeFormat().resolvedOptions().timeZone
      if (!tz) return

      const existing = this.getCookie("timezone")
      if (existing === tz) return

      // 1 year persistence
      const maxAge = 60 * 60 * 24 * 365
      document.cookie = `timezone=${encodeURIComponent(tz)}; path=/; max-age=${maxAge}`
    } catch (e) {
      // ignore
    }
  }

  formatTimes() {
    const nodes = this.hasTimeTarget ? this.timeTargets : this.findTimeNodes()
    if (!nodes || nodes.length === 0) return

    nodes.forEach((el) => {
      const iso = el.getAttribute("data-utc") || el.getAttribute("datetime")
      if (!iso) return
      const date = new Date(iso)
      if (isNaN(date.getTime())) return

      const formatted = this.formatDate(date)
      el.textContent = formatted
    })
  }

  formatDate(date) {
    // Using Intl API for locale-aware formatting. Build a format close to "YYYY-MM-DD HH:mm"
    const opts = { year: "numeric", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", hour12: false }
    const parts = new Intl.DateTimeFormat(undefined, opts).formatToParts(date)
    const map = {}
    parts.forEach(p => { map[p.type] = p.value })
    // Some locales order parts differently; reconstruct deterministic format
    return `${map.year}-${map.month}-${map.day} ${map.hour}:${map.minute}`
  }

  findTimeNodes() {
    // default: any <time data-utc> within this controller element
    return this.element.querySelectorAll("time[data-utc]")
  }

  getCookie(name) {
    const match = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/([.$?*|{}()\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"))
    return match ? decodeURIComponent(match[1]) : null
  }
}
