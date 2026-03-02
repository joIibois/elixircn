import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import hljs from "highlight.js/lib/core"
import elixir from "highlight.js/lib/languages/elixir"
import xml from "highlight.js/lib/languages/xml"

hljs.registerLanguage("elixir", elixir)
hljs.registerLanguage("xml", xml)

let Hooks = {}

// Carousel: track current index, translate slides on prev/next events
Hooks.Carousel = {
  mounted() {
    this.index = 0
    this.el.addEventListener("carousel:prev", () => this.move(-1))
    this.el.addEventListener("carousel:next", () => this.move(1))
  },
  updated() {
    // Re-clamp index in case the number of slides changed after a server patch
    const slides = this.el.querySelectorAll('[role="group"][aria-roledescription="slide"]')
    this.index = Math.max(0, Math.min(slides.length - 1, this.index))
    const track = this.el.querySelector("[data-carousel-track]")
    if (track) track.style.transform = `translateX(-${this.index * 100}%)`
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
    this._clickHandler = () => {
      const menu = document.getElementById(menuId)
      if (menu) menu.style.display = "none"
    }
    document.addEventListener("click", this._clickHandler)
  },
  destroyed() {
    if (this._clickHandler) document.removeEventListener("click", this._clickHandler)
  }
}

// Resizable: drag handle to resize panels
Hooks.Resizable = {
  mounted() {
    this._docListeners = []
    this.setupHandles()
  },
  updated() {
    // Re-attach listeners when LiveView patches handles (e.g. panels added/removed)
    this._docListeners.forEach(({ type, handler }) => document.removeEventListener(type, handler))
    this._docListeners = []
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

      const mousemoveHandler = (e) => {
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
      }

      const mouseupHandler = () => {
        dragging = false
        document.body.style.cursor = ""
        document.body.style.userSelect = ""
      }

      document.addEventListener("mousemove", mousemoveHandler)
      document.addEventListener("mouseup", mouseupHandler)
      this._docListeners.push(
        { type: "mousemove", handler: mousemoveHandler },
        { type: "mouseup", handler: mouseupHandler }
      )
    })
  },
  destroyed() {
    if (this._docListeners) {
      this._docListeners.forEach(({ type, handler }) => {
        document.removeEventListener(type, handler)
      })
    }
  }
}

// ComboboxFilter: client-side option filtering based on search input text
Hooks.ComboboxFilter = {
  mounted() {
    this._setup()
  },
  updated() {
    // Re-run setup so newly-rendered options are covered after a server patch
    if (this.observer) this.observer.disconnect()
    this._setup()
  },
  _setup() {
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

// HighlightCode: apply syntax highlighting to a <code> block inside the element
Hooks.HighlightCode = {
  mounted()  { this.highlight() },
  updated()  { this.highlight() },
  highlight() {
    const code = this.el.querySelector("code")
    if (code) {
      delete code.dataset.highlighted
      hljs.highlightElement(code)
    }
  }
}

// CopyCode: copy <pre> text to clipboard, show checkmark feedback
Hooks.CopyCode = {
  mounted() {
    this._resetTimer = null
    this.el.addEventListener("click", () => {
      const target = document.getElementById(this.el.dataset.target)
      if (!target) return
      const code = target.querySelector("code") || target
      navigator.clipboard.writeText(code.textContent.trim()).then(() => {
        const copyIcon  = this.el.querySelector("[data-copy-icon]")
        const checkIcon = this.el.querySelector("[data-check-icon]")
        if (copyIcon)  copyIcon.classList.add("hidden")
        if (checkIcon) checkIcon.classList.remove("hidden")
        if (this._resetTimer) clearTimeout(this._resetTimer)
        this._resetTimer = setTimeout(() => {
          if (copyIcon)  copyIcon.classList.remove("hidden")
          if (checkIcon) checkIcon.classList.add("hidden")
          this._resetTimer = null
        }, 2000)
      })
    })
  },
  destroyed() {
    if (this._resetTimer) clearTimeout(this._resetTimer)
  }
}

// InputOTP: auto-advance focus between OTP input digits
Hooks.InputOtp = {
  mounted() {
    this._bindInputs()
  },
  updated() {
    // Re-bind when the server patches the number of inputs (e.g. length change)
    this._bindInputs()
  },
  _bindInputs() {
    const mode = this.el.dataset.otpMode || "numeric"
    // Clone all inputs first to strip previously-bound listeners
    this.el.querySelectorAll("[data-otp-input]").forEach((input) => {
      input.replaceWith(input.cloneNode(true))
    })
    // Re-query to get live references to the new DOM nodes
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
        let text = (e.clipboardData || window.clipboardData).getData("text")
        text = mode === "numeric" ? text.replace(/\D/g, "") : text.replace(/[^a-zA-Z0-9]/g, "")
        inputs.forEach((inp, idx) => {
          inp.value = text[idx] || ""
        })
        const last = Math.min(text.length, inputs.length - 1)
        inputs[last].focus()
      })
    })
  }
}

// Menu: keyboard navigation with ArrowUp/ArrowDown/Home/End for role="menu" containers.
// Also handles Enter/Space to activate the focused item and Escape to close.
Hooks.Menu = {
  mounted() {
    this.el.addEventListener("keydown", (e) => {
      const items = Array.from(this.el.querySelectorAll('[role="menuitem"]:not([aria-disabled="true"])'))
      if (!items.length) return
      const current = items.indexOf(document.activeElement)
      let next
      switch (e.key) {
        case "ArrowDown": next = current < items.length - 1 ? current + 1 : 0; break
        case "ArrowUp":   next = current > 0 ? current - 1 : items.length - 1; break
        case "Home":      next = 0; break
        case "End":       next = items.length - 1; break
        case "Enter":
        case " ":
          if (current !== -1) { e.preventDefault(); items[current].click() }
          return
        default: return
      }
      e.preventDefault()
      items[next].focus()
    })

    // Focus the first menu item when the menu becomes visible
    this._observer = new MutationObserver(() => {
      if (this.el.offsetParent !== null || this.el.offsetWidth > 0) {
        const first = this.el.querySelector('[role="menuitem"]:not([aria-disabled="true"])')
        if (first) first.focus()
      }
    })
    this._observer.observe(this.el, { attributes: true, attributeFilter: ["class", "style"] })
  },
  destroyed() {
    if (this._observer) this._observer.disconnect()
  }
}

// Menubar: ArrowLeft/ArrowRight between top-level menubar triggers
Hooks.MenubarNav = {
  mounted() {
    this.el.addEventListener("keydown", (e) => {
      if (e.key !== "ArrowLeft" && e.key !== "ArrowRight") return
      const triggers = Array.from(this.el.querySelectorAll(':scope > div > [role="menuitem"][aria-haspopup="menu"]'))
      if (!triggers.length) return
      // Check if focus is on a trigger or inside a sub-menu
      const activeTrigger = triggers.find(t =>
        t === document.activeElement || t.closest("div")?.querySelector('[role="menu"]')?.contains(document.activeElement)
      )
      if (!activeTrigger) return
      const idx = triggers.indexOf(activeTrigger)
      let next
      if (e.key === "ArrowRight") next = (idx + 1) % triggers.length
      else next = (idx - 1 + triggers.length) % triggers.length
      e.preventDefault()
      triggers[next].click()
      triggers[next].focus()
    })
  }
}

// Tabs: keyboard navigation with ArrowLeft/ArrowRight/Home/End.
// After a LiveView patch the server re-renders tabs with the original `active`
// assigns, which resets `data-state`, `aria-selected`, classes, and `hidden` to
// their initial values.  The `updated` callback snapshots the client-side active
// tab *before* morphdom runs and restores it afterwards so tab switching (which
// is purely client-side via JS commands) survives server patches.
Hooks.Tabs = {
  mounted() {
    this.el.addEventListener("keydown", (e) => {
      const tabs = Array.from(this.el.querySelectorAll("[role=tab]:not([disabled])"))
      if (!tabs.length) return
      const current = tabs.indexOf(document.activeElement)
      if (current === -1) return
      let next
      switch (e.key) {
        case "ArrowRight": next = (current + 1) % tabs.length; break
        case "ArrowLeft": next = (current - 1 + tabs.length) % tabs.length; break
        case "Home": next = 0; break
        case "End": next = tabs.length - 1; break
        default: return
      }
      e.preventDefault()
      tabs[next].focus()
      tabs[next].click()
    })
  },
  beforeUpdate() {
    // Snapshot the currently active tab value before LiveView patches the DOM
    const active = this.el.querySelector('[role=tab][data-state=active]')
    this._activeTabId = active ? active.id : null
  },
  updated() {
    // Restore client-side active tab state after LiveView patch
    if (!this._activeTabId) return
    const tabsRoot = this.el.closest("[data-tabs]")
    if (!tabsRoot) return

    const activeTab = document.getElementById(this._activeTabId)
    if (!activeTab) return

    // Reset all tabs to inactive
    tabsRoot.querySelectorAll("[role=tab]").forEach(tab => {
      tab.setAttribute("data-state", "inactive")
      tab.setAttribute("aria-selected", "false")
      tab.classList.remove("bg-background", "text-foreground", "shadow")
    })

    // Reset all panels to inactive/hidden
    tabsRoot.querySelectorAll("[role=tabpanel]").forEach(panel => {
      panel.setAttribute("data-state", "inactive")
      panel.setAttribute("hidden", "true")
    })

    // Activate the snapshotted tab
    activeTab.setAttribute("data-state", "active")
    activeTab.setAttribute("aria-selected", "true")
    activeTab.classList.add("bg-background", "text-foreground", "shadow")

    // Activate the corresponding panel
    const panelId = activeTab.getAttribute("aria-controls")
    const panel = panelId ? document.getElementById(panelId) : null
    if (panel) {
      panel.setAttribute("data-state", "active")
      panel.removeAttribute("hidden")
    }
  }
}

// Toast: auto-dismiss after configurable delay
Hooks.Toast = {
  mounted() {
    const delay = parseInt(this.el.dataset.autoDismiss || "5000", 10)
    if (delay > 0) {
      this._timer = setTimeout(() => {
        this.el.style.transition = "opacity 150ms ease-in, transform 150ms ease-in"
        this.el.style.opacity = "0"
        this.el.style.transform = "translateY(0.5rem)"
        // Hide the element instead of removing it so LiveView stays in sync.
        // The server can clean up the toast from assigns on the next render.
        setTimeout(() => { this.el.style.display = "none" }, 150)
      }, delay)
    }
  },
  destroyed() {
    if (this._timer) clearTimeout(this._timer)
  }
}

// FocusTrap: trap Tab/Shift+Tab within a modal so focus cannot escape.
Hooks.FocusTrap = {
  mounted() {
    this._onKeyDown = (e) => {
      if (e.key !== "Tab") return
      const focusable = Array.from(
        this.el.querySelectorAll(
          'a[href], button:not([disabled]), input:not([disabled]), textarea:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])'
        )
      ).filter(el => el.offsetParent !== null || el.offsetWidth > 0 || el.offsetHeight > 0)
      if (!focusable.length) return
      const first = focusable[0]
      const last = focusable[focusable.length - 1]
      if (e.shiftKey) {
        if (document.activeElement === first || !this.el.contains(document.activeElement)) {
          e.preventDefault()
          last.focus()
        }
      } else {
        if (document.activeElement === last || !this.el.contains(document.activeElement)) {
          e.preventDefault()
          first.focus()
        }
      }
    }
    this.el.addEventListener("keydown", this._onKeyDown)
  },
  destroyed() {
    if (this._onKeyDown) this.el.removeEventListener("keydown", this._onKeyDown)
  }
}

// AvatarFallback: show fallback on image error without inline JS
Hooks.AvatarFallback = {
  mounted() {
    const img = this.el.querySelector("img")
    if (!img) return
    this._errorHandler = () => {
      const fallback = this.el.querySelector("[data-avatar-fallback]")
      if (fallback) fallback.style.display = "flex"
    }
    img.addEventListener("error", this._errorHandler)
  },
  destroyed() {
    const img = this.el.querySelector("img")
    if (img && this._errorHandler) img.removeEventListener("error", this._errorHandler)
  }
}

// SelectLabel: update label text on custom set-label event
Hooks.SelectLabel = {
  mounted() {
    this._handler = (e) => {
      if (e.detail && e.detail.label) this.el.textContent = e.detail.label
    }
    this.el.addEventListener("set-label", this._handler)
  },
  destroyed() {
    if (this._handler) this.el.removeEventListener("set-label", this._handler)
  }
}

// Global Escape key handler — closes only the topmost visible overlay.
// Uses el.offsetParent as a fast visibility check (null when display:none or
// hidden by an ancestor). This avoids getComputedStyle layout thrashing.
// The last visible element in DOM order is treated as topmost, which is correct
// for this library since overlays share z-50 and open in DOM order.
function isVisible(el) {
  // offsetParent is null for display:none elements and for elements with
  // a hidden ancestor, but also for fixed-position elements. Since our
  // backdrops are position:fixed, fall back to checking offsetWidth/Height
  // which are 0 for truly hidden elements.
  return el.offsetParent !== null || el.offsetWidth > 0 || el.offsetHeight > 0
}

document.addEventListener("keydown", (e) => {
  if (e.key !== "Escape") return

  // Context menus (always close all, they sit on top of everything)
  let closedContext = false
  document.querySelectorAll("[data-context-menu-content]").forEach(el => {
    if (el.style.display === "block") {
      el.style.display = "none"
      closedContext = true
    }
  })
  if (closedContext) return

  // Find the last visible escape-close element (topmost in DOM order)
  const escapeTargets = Array.from(document.querySelectorAll("[data-escape-close]"))
  for (let i = escapeTargets.length - 1; i >= 0; i--) {
    if (isVisible(escapeTargets[i])) {
      escapeTargets[i].click()
      return
    }
  }

  // Dropdowns with no backdrop (select)
  const hideTargets = Array.from(document.querySelectorAll("[data-escape-hide]"))
  for (let i = hideTargets.length - 1; i >= 0; i--) {
    if (isVisible(hideTargets[i])) {
      hideTargets[i].style.display = "none"
      return
    }
  }
})

const csrfMeta = document.querySelector("meta[name='csrf-token']")
const csrfToken = csrfMeta ? csrfMeta.getAttribute("content") : ""
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
