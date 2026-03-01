import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {}

// Carousel: track current index, translate slides on prev/next events
Hooks.Carousel = {
  mounted() {
    this.index = 0
    this.el.addEventListener("carousel:prev", () => this.move(-1))
    this.el.addEventListener("carousel:next", () => this.move(1))
  },
  move(delta) {
    const slides = this.el.querySelectorAll('[role="group"][aria-roledescription="slide"]')
    this.index = Math.max(0, Math.min(slides.length - 1, this.index + delta))
    const track = this.el.querySelector("[data-carousel-track]")
    if (track) track.style.transform = `translateX(-${this.index * 100}%)`
  }
}

// ContextMenu: position menu at cursor on right-click
Hooks.ContextMenu = {
  mounted() {
    const menuId = this.el.dataset.menuTarget
    this.el.addEventListener("contextmenu", (e) => {
      e.preventDefault()
      const menu = document.getElementById(menuId)
      if (!menu) return
      menu.style.display = "block"
      const x = Math.min(e.clientX, window.innerWidth - menu.offsetWidth - 8)
      const y = Math.min(e.clientY, window.innerHeight - menu.offsetHeight - 8)
      menu.style.left = x + "px"
      menu.style.top  = y + "px"
    })
    document.addEventListener("click", () => {
      const menu = document.getElementById(menuId)
      if (menu) menu.style.display = "none"
    })
  }
}

// Resizable: drag handle to resize panels
Hooks.Resizable = {
  mounted() {
    this.setupHandles()
  },
  setupHandles() {
    const handles = this.el.querySelectorAll("[data-resize-handle]")
    handles.forEach(handle => {
      let dragging = false, startX = 0, startY = 0
      const group = handle.closest("[data-panel-group]")
      const panels = group ? Array.from(group.querySelectorAll("[data-panel]")) : []
      const dir = group ? group.dataset.direction : "horizontal"
      const handleIdx = Array.from(group.querySelectorAll("[data-resize-handle]")).indexOf(handle)

      handle.addEventListener("mousedown", (e) => {
        dragging = true
        startX = e.clientX
        startY = e.clientY
        e.preventDefault()
        document.body.style.cursor = dir === "horizontal" ? "col-resize" : "row-resize"
        document.body.style.userSelect = "none"
      })

      document.addEventListener("mousemove", (e) => {
        if (!dragging || panels.length < 2) return
        const panelA = panels[handleIdx]
        const panelB = panels[handleIdx + 1]
        if (!panelA || !panelB) return
        const totalSize = dir === "horizontal"
          ? group.getBoundingClientRect().width
          : group.getBoundingClientRect().height
        const delta = dir === "horizontal" ? e.clientX - startX : e.clientY - startY
        const aSize = parseFloat(panelA.style.flex || "50")
        const bSize = parseFloat(panelB.style.flex || "50")
        const pixelsPerPercent = totalSize / 100
        const deltaPct = delta / pixelsPerPercent
        const newA = Math.max(10, Math.min(90, aSize + deltaPct))
        const newB = Math.max(10, Math.min(90, bSize - deltaPct))
        panelA.style.flex = newA
        panelB.style.flex = newB
        startX = e.clientX
        startY = e.clientY
      })

      document.addEventListener("mouseup", () => {
        dragging = false
        document.body.style.cursor = ""
        document.body.style.userSelect = ""
      })
    })
  }
}

// ComboboxFilter: client-side option filtering based on search input text
Hooks.ComboboxFilter = {
  mounted() {
    const dropdown = this.el.closest("[data-combobox-dropdown]")

    this.el.addEventListener("input", () => {
      const query = this.el.value.toLowerCase()
      if (!dropdown) return
      dropdown.querySelectorAll("[role=option]").forEach(opt => {
        const text = opt.textContent.trim().toLowerCase()
        opt.style.display = text.includes(query) ? "" : "none"
      })
    })

    if (dropdown) {
      this.observer = new MutationObserver(() => {
        if (dropdown.style.display === "none") {
          this.el.value = ""
          dropdown.querySelectorAll("[role=option]").forEach(opt => {
            opt.style.display = ""
          })
        }
      })
      this.observer.observe(dropdown, { attributes: true, attributeFilter: ["style"] })
    }
  },
  destroyed() {
    if (this.observer) this.observer.disconnect()
  }
}

// CopyCode: copy <pre> text to clipboard, show checkmark feedback
Hooks.CopyCode = {
  mounted() {
    this.el.addEventListener("click", () => {
      const target = document.getElementById(this.el.dataset.target)
      if (!target) return
      navigator.clipboard.writeText(target.textContent.trim()).then(() => {
        const copyIcon  = this.el.querySelector("[data-copy-icon]")
        const checkIcon = this.el.querySelector("[data-check-icon]")
        if (copyIcon)  copyIcon.classList.add("hidden")
        if (checkIcon) checkIcon.classList.remove("hidden")
        setTimeout(() => {
          if (copyIcon)  copyIcon.classList.remove("hidden")
          if (checkIcon) checkIcon.classList.add("hidden")
        }, 2000)
      })
    })
  }
}

// InputOTP: auto-advance focus between OTP input digits
Hooks.InputOtp = {
  mounted() {
    const inputs = this.el.querySelectorAll("[data-otp-input]")
    inputs.forEach((input, i) => {
      input.addEventListener("input", (e) => {
        if (e.target.value.length >= 1 && i < inputs.length - 1) {
          inputs[i + 1].focus()
        }
      })
      input.addEventListener("keydown", (e) => {
        if (e.key === "Backspace" && !e.target.value && i > 0) {
          inputs[i - 1].focus()
        }
      })
      input.addEventListener("paste", (e) => {
        e.preventDefault()
        const text = (e.clipboardData || window.clipboardData).getData("text").replace(/\D/g, "")
        inputs.forEach((inp, idx) => {
          inp.value = text[idx] || ""
        })
        const last = Math.min(text.length, inputs.length - 1)
        inputs[last].focus()
      })
    })
  }
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})

topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop",  _info => topbar.hide())

liveSocket.connect()
window.liveSocket = liveSocket

if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    reloader.enableServerLogs()
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if (keyDown === "c") {
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if (keyDown === "d") {
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)
    window.liveReloader = reloader
  })
}
