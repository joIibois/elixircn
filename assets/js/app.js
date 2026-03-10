import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import hljs from "highlight.js/lib/core"
import elixir from "highlight.js/lib/languages/elixir"
import xml from "highlight.js/lib/languages/xml"
import bash from "highlight.js/lib/languages/bash"
import javascript from "highlight.js/lib/languages/javascript"
import css from "highlight.js/lib/languages/css"

hljs.registerLanguage("elixir", elixir)
hljs.registerLanguage("xml", xml)
hljs.registerLanguage("bash", bash)
hljs.registerLanguage("shell", bash)
hljs.registerLanguage("javascript", javascript)
hljs.registerLanguage("js", javascript)
hljs.registerLanguage("css", css)
hljs.registerLanguage("heex", xml)

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

// Resizable: drag handle to resize panels, with keyboard support on handles
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

      // Keyboard resize: Arrow keys move by 1%, Shift+Arrow by 10%
      handle.addEventListener("keydown", (e) => {
        const relevant = dir === "horizontal"
          ? (e.key === "ArrowLeft" || e.key === "ArrowRight")
          : (e.key === "ArrowUp" || e.key === "ArrowDown")
        if (!relevant || panels.length < 2) return
        e.preventDefault()
        const panelA = panels[handleIdx]
        const panelB = panels[handleIdx + 1]
        if (!panelA || !panelB) return
        const step = e.shiftKey ? 10 : 1
        const aSize = parseFloat(panelA.style.flex || "50")
        const bSize = parseFloat(panelB.style.flex || "50")
        const grow = (dir === "horizontal" && e.key === "ArrowRight") ||
                     (dir === "vertical"   && e.key === "ArrowDown")
        const deltaPct = grow ? step : -step
        const newA = Math.max(10, Math.min(90, aSize + deltaPct))
        const newB = Math.max(10, Math.min(90, bSize - deltaPct))
        panelA.style.flex = `${newA} 1 0%`
        panelB.style.flex = `${newB} 1 0%`
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
        if (!totalSize) return
        const pixelsPerPercent = totalSize / 100
        const deltaPct = delta / pixelsPerPercent
        const newA = Math.max(10, Math.min(90, aSize + deltaPct))
        const newB = Math.max(10, Math.min(90, bSize - deltaPct))
        panelA.style.flex = `${newA} 1 0%`
        panelB.style.flex = `${newB} 1 0%`
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

// SelectNav: full keyboard navigation for the custom select listbox.
// ArrowUp/Down move between options, Enter selects, Escape/Tab closes.
//
// Visibility note: JS.toggle works by setting/clearing inline style.display.
// The options div starts with class="hidden ..." but JS.toggle never touches
// that class — it only sets style.display="none" (closed) or removes the
// inline style (open). So the correct open check is:
//   style.display !== "none"  (inline style not forcing hidden)
// We must NOT check classList.contains("hidden") because that class is static.
Hooks.SelectNav = {
  mounted() {
    this._onKeyDown = (e) => {
      const dropdown = this.el.querySelector("[data-select-options]")
      // Open = inline style is not "none" (JS.toggle removed the override)
      const isOpen = dropdown && dropdown.style.display !== "none"
      if (!isOpen) {
        // Open on ArrowDown/ArrowUp/Enter/Space when closed
        if (e.key === "ArrowDown" || e.key === "ArrowUp" || e.key === "Enter" || e.key === " ") {
          e.preventDefault()
          const trigger = this.el.querySelector("[data-select-trigger]")
          if (trigger) trigger.click()
        }
        return
      }
      const options = Array.from(this.el.querySelectorAll('[role="option"]:not([aria-disabled="true"])'))
        .filter(o => o.style.display !== "none")
      const current = options.indexOf(document.activeElement)

      switch (e.key) {
        case "ArrowDown":
          e.preventDefault()
          if (!options.length) return
          options[current < options.length - 1 ? current + 1 : 0].focus()
          break
        case "ArrowUp":
          e.preventDefault()
          if (!options.length) return
          options[current > 0 ? current - 1 : options.length - 1].focus()
          break
        case "Home":
          e.preventDefault()
          if (options.length) options[0].focus()
          break
        case "End":
          e.preventDefault()
          if (options.length) options[options.length - 1].focus()
          break
        case "Enter":
        case " ":
          e.preventDefault()
          if (current !== -1) options[current].click()
          break
        case "Tab":
          // Close on Tab and let focus move naturally
          e.preventDefault()
          {
            const backdrop = this.el.querySelector("[data-select-backdrop]")
            if (backdrop) backdrop.click()
            const trigger = this.el.querySelector("[data-select-trigger]")
            if (trigger) trigger.focus()
          }
          break
        case "Escape":
          e.preventDefault()
          e.stopPropagation()
          {
            const backdrop = this.el.querySelector("[data-select-backdrop]")
            if (backdrop) backdrop.click()
            const trigger = this.el.querySelector("[data-select-trigger]")
            if (trigger) trigger.focus()
          }
          break
      }
    }
    this.el.addEventListener("keydown", this._onKeyDown)

    // Focus first option when dropdown opens.
    // JS.toggle sets/clears inline style.display, so observe the style attribute.
    this._observer = new MutationObserver(() => {
      const dropdown = this.el.querySelector("[data-select-options]")
      if (!dropdown) return
      if (dropdown.style.display !== "none") {
        const first = dropdown.querySelector('[role="option"]:not([aria-disabled="true"])')
        if (first) first.focus()
      }
    })
    const dropdown = this.el.querySelector("[data-select-options]")
    if (dropdown) this._observer.observe(dropdown, { attributes: true, attributeFilter: ["style"] })
  },
  destroyed() {
    if (this._onKeyDown) this.el.removeEventListener("keydown", this._onKeyDown)
    if (this._observer) this._observer.disconnect()
  }
}

// ComboboxNav: keyboard navigation for the combobox dropdown list.
// ArrowUp/Down on the search input move focus into the options list;
// Enter selects; Escape closes. When focus is on an option ArrowUp
// returns focus to the search input.
Hooks.ComboboxNav = {
  mounted() {
    this._onKeyDown = (e) => {
      const dropdown = this.el.querySelector("[data-combobox-dropdown]")
      const isOpen = dropdown && dropdown.style.display !== "none"

      // When the dropdown is closed, open it on ArrowDown/ArrowUp
      if (!isOpen) {
        if (e.key === "ArrowDown" || e.key === "ArrowUp") {
          e.preventDefault()
          const trigger = this.el.querySelector("[data-combobox-trigger]")
          if (trigger) trigger.click()
        }
        return
      }

      const search = this.el.querySelector("[data-combobox-search]")
      const options = Array.from(this.el.querySelectorAll('[role="option"]'))
        .filter(o => o.style.display !== "none")
      if (!options.length && e.key !== "Escape") return

      const current = options.indexOf(document.activeElement)
      switch (e.key) {
        case "ArrowDown":
          e.preventDefault()
          if (current === -1) {
            if (options.length) options[0].focus()
          } else {
            options[current < options.length - 1 ? current + 1 : 0].focus()
          }
          break
        case "ArrowUp":
          e.preventDefault()
          if (current <= 0) {
            if (search) search.focus()
          } else {
            options[current - 1].focus()
          }
          break
        case "Home":
          if (current !== -1) { e.preventDefault(); options[0].focus() }
          break
        case "End":
          if (current !== -1) { e.preventDefault(); options[options.length - 1].focus() }
          break
        case "Enter":
          if (current !== -1) { e.preventDefault(); options[current].click() }
          break
        case "Escape":
          e.preventDefault()
          e.stopPropagation()
          {
            const backdrop = this.el.querySelector("[data-combobox-backdrop]")
            if (backdrop) backdrop.click()
          }
          break
      }
    }
    this.el.addEventListener("keydown", this._onKeyDown)
  },
  destroyed() {
    if (this._onKeyDown) this.el.removeEventListener("keydown", this._onKeyDown)
  }
}

// ComboboxFilter: client-side option filtering based on search input text
Hooks.ComboboxFilter = {
  mounted() {
    const dropdown = this.el.closest("[data-combobox-dropdown]")

    // Bind the input handler once and keep a reference for cleanup
    this._onInput = () => {
      const query = this.el.value.toLowerCase()
      if (!dropdown) return
      dropdown.querySelectorAll("[role=option]").forEach(opt => {
        const text = opt.textContent.trim().toLowerCase()
        opt.style.display = text.includes(query) ? "" : "none"
      })
    }
    this.el.addEventListener("input", this._onInput)

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
    if (this._onInput) this.el.removeEventListener("input", this._onInput)
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

// HighlightAllCode: wrap each <pre> in the same code block chrome used by the component showcase
Hooks.HighlightAllCode = {
  mounted()  { this.highlight() },
  updated()  { this.highlight() },
  highlight() {
    this.el.querySelectorAll("pre:not([data-hljs-wrapped])").forEach(pre => {
      const code = pre.querySelector("code")
      if (!code) return

      // Determine language label from earmark's class="language-X"
      const langClass = [...code.classList].find(c => c.startsWith("language-"))
      const lang = langClass ? langClass.replace("language-", "") : "code"

      // Run hljs
      delete code.dataset.highlighted
      hljs.highlightElement(code)
      code.classList.add("!bg-transparent")

      // Style the <pre> to match the component showcase code block
      pre.removeAttribute("class")
      pre.classList.add("overflow-x-auto", "p-5", "text-sm", "leading-relaxed")
      pre.dataset.hljsWrapped = "true"

      // Build wrapper identical to the component showcase code block
      const wrapper = document.createElement("div")
      wrapper.className = "rounded-xl overflow-hidden border border-zinc-200 dark:border-zinc-800 bg-zinc-950 not-prose my-6"

      const header = document.createElement("div")
      header.className = "flex items-center border-b border-zinc-800 px-4 py-2.5"
      header.innerHTML = `<span class="font-mono text-xs text-zinc-500">${lang}</span>`

      pre.parentNode.insertBefore(wrapper, pre)
      wrapper.appendChild(header)
      wrapper.appendChild(pre)
    })
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

    // Focus the first menu item when the menu becomes visible.
    // setTimeout(0) defers past the browser's click-focus on <button> triggers,
    // which would otherwise steal focus back after our focus() call.
    this._observer = new MutationObserver(() => {
      if (this.el.offsetParent !== null || this.el.offsetWidth > 0) {
        const first = this.el.querySelector('[role="menuitem"]:not([aria-disabled="true"])')
        if (first) setTimeout(() => first.focus(), 0)
      }
    })
    this._observer.observe(this.el, { attributes: true, attributeFilter: ["class", "style"] })
  },
  destroyed() {
    if (this._observer) this._observer.disconnect()
  }
}

// Menubar: ArrowLeft/ArrowRight between top-level menubar triggers
// Also handles hover-to-open: when any menu is already open, hovering a
// different trigger instantly opens it (matching native menubar UX).
Hooks.MenubarNav = {
  mounted() {
    const menubar = this.el

    // Keyboard: ArrowLeft/ArrowRight between top-level triggers
    menubar.addEventListener("keydown", (e) => {
      if (e.key !== "ArrowLeft" && e.key !== "ArrowRight") return
      const triggers = Array.from(menubar.querySelectorAll(':scope > div > [role="menuitem"][aria-haspopup="menu"]'))
      if (!triggers.length) return
      const activeTrigger = triggers.find(t =>
        t === document.activeElement || t.closest("div")?.querySelector('[role="menu"]')?.contains(document.activeElement)
      )
      if (!activeTrigger) return
      const idx = triggers.indexOf(activeTrigger)
      const next = e.key === "ArrowRight" ? (idx + 1) % triggers.length : (idx - 1 + triggers.length) % triggers.length
      e.preventDefault()
      triggers[next].click()
      triggers[next].focus()
    })

    // Hover-to-open: same pattern as Radix UI.
    // The backdrop is now a hidden state-flag only (no pointer-event blocking),
    // so triggers receive pointerenter naturally.
    menubar.addEventListener("pointerenter", (e) => {
      const trigger = e.target.closest('[role="menuitem"][aria-haspopup="menu"]')
      if (!trigger || !menubar.contains(trigger)) return
      const anyOpen = Array.from(menubar.querySelectorAll('[role="menu"]')).some(m => m.offsetHeight > 0)
      if (!anyOpen) return
      // Find this trigger's associated menu panel
      const menu = trigger.closest("div")?.querySelector('[role="menu"]')
      const alreadyOpen = menu && menu.offsetHeight > 0
      if (!alreadyOpen) {
        trigger.click()
        trigger.focus()
      }
    }, true)

    // Sync data-state="open" on each trigger whenever its menu panel visibility changes.
    // This drives the trigger's open-state styles (bg-accent etc.) via data-[state=open]:*.
    const syncStates = () => {
      menubar.querySelectorAll(':scope > div > [role="menuitem"][aria-haspopup="menu"]').forEach(trigger => {
        const menu = trigger.closest("div")?.querySelector('[role="menu"]')
        if (menu) trigger.dataset.state = menu.offsetHeight > 0 ? "open" : "closed"
      })
    }
    this._stateObserver = new MutationObserver(syncStates)
    menubar.querySelectorAll('[role="menu"]').forEach(menu => {
      this._stateObserver.observe(menu, { attributes: true, attributeFilter: ["style", "class"] })
    })

    // Click outside to close: replaces the old fixed-inset backdrop approach.
    this._onPointerDown = (e) => {
      const anyOpen = Array.from(menubar.querySelectorAll('[role="menu"]')).some(m => m.offsetHeight > 0)
      if (!anyOpen) return
      if (!menubar.contains(e.target)) {
        menubar.querySelectorAll('[role="menu"]').forEach(m => {
          if (m.offsetHeight > 0) m.style.display = "none"
        })
        syncStates()
      }
    }
    document.addEventListener("pointerdown", this._onPointerDown)
  },
  destroyed() {
    document.removeEventListener("pointerdown", this._onPointerDown)
    if (this._stateObserver) this._stateObserver.disconnect()
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
    // Initialize: if no tab is already active (server rendered with active=true),
    // activate the default tab (from data-default-tab) or fall back to the first tab.
    const tabsRoot = this.el.closest("[data-tabs]")
    if (tabsRoot) {
      const hasActive = tabsRoot.querySelector('[role=tab][data-state=active]')
      if (!hasActive) {
        const defaultValue = tabsRoot.dataset.defaultTab
        const target = defaultValue
          ? document.getElementById(`${tabsRoot.id}-tab-${defaultValue}`)
          : this.el.querySelector('[role=tab]:not([disabled])')
        if (target) target.click()
      }
    }

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

// AccordionTrigger: handles toggle logic and preserves client-side open/closed
// state across LiveView patches. Reads accordion type from the parent container's
// data-accordion-type attribute so callers don't need to pass it on each trigger.
Hooks.AccordionTrigger = {
  mounted() {
    this._onClick = () => this._toggle()
    this.el.addEventListener("click", this._onClick)
  },
  destroyed() {
    if (this._onClick) this.el.removeEventListener("click", this._onClick)
  },
  beforeUpdate() {
    this._state = this.el.getAttribute("data-state")
    this._expanded = this.el.getAttribute("aria-expanded")
  },
  updated() {
    if (this._state) this.el.setAttribute("data-state", this._state)
    if (this._expanded) this.el.setAttribute("aria-expanded", this._expanded)
    // Sync the chevron icon rotation class
    const iconId = this.el.id.replace("-trigger-", "-icon-")
    const icon = document.getElementById(iconId)
    if (icon) {
      if (this._state === "open") {
        icon.classList.add("rotate-180")
      } else {
        icon.classList.remove("rotate-180")
      }
    }
  },
  _toggle() {
    // Derive accordion id from trigger id: "<accordionId>-trigger-<value>"
    const triggerId = this.el.id
    const match = triggerId.match(/^(.+)-trigger-(.+)$/)
    if (!match) return
    const accordionId = match[1]
    const value = match[2]

    const accordion = document.getElementById(accordionId)
    const type = accordion ? (accordion.dataset.accordionType || "multiple") : "multiple"

    if (type === "single") {
      // Close all other open triggers and their content panels
      accordion.querySelectorAll("button[data-state=open]").forEach(btn => {
        if (btn !== this.el) {
          btn.setAttribute("data-state", "closed")
          btn.setAttribute("aria-expanded", "false")
          const otherId = btn.id.match(/^(.+)-trigger-(.+)$/)?.[2]
          if (otherId) {
            const otherContent = document.getElementById(`${accordionId}-content-${otherId}`)
            if (otherContent) otherContent.setAttribute("data-state", "closed")
            const otherIcon = document.getElementById(`${accordionId}-icon-${otherId}`)
            if (otherIcon) otherIcon.classList.remove("rotate-180")
          }
        }
      })
    }

    // Toggle current item
    const isOpen = this.el.getAttribute("data-state") === "open"
    const newState = isOpen ? "closed" : "open"
    this.el.setAttribute("data-state", newState)
    this.el.setAttribute("aria-expanded", String(!isOpen))

    const content = document.getElementById(`${accordionId}-content-${value}`)
    if (content) content.setAttribute("data-state", newState)

    const icon = document.getElementById(`${accordionId}-icon-${value}`)
    if (icon) icon.classList.toggle("rotate-180", !isOpen)
  }
}

// AccordionContent: preserve client-side open/closed state across LiveView patches.
Hooks.AccordionContent = {
  beforeUpdate() {
    this._state = this.el.getAttribute("data-state")
  },
  updated() {
    if (this._state) this.el.setAttribute("data-state", this._state)
  }
}

// CollapsibleContent: preserve client-side visibility across LiveView patches.
Hooks.CollapsibleContent = {
  beforeUpdate() {
    this._hidden = this.el.style.display === "none"
  },
  updated() {
    if (this._hidden) {
      this.el.style.display = "none"
    } else {
      this.el.style.display = ""
    }
  }
}

// Toggle: preserve client-side pressed state (data-state, aria-pressed) across LiveView patches.
Hooks.Toggle = {
  beforeUpdate() {
    this._state = this.el.getAttribute("data-state")
    this._pressed = this.el.getAttribute("aria-pressed")
  },
  updated() {
    if (this._state) this.el.setAttribute("data-state", this._state)
    if (this._pressed) this.el.setAttribute("aria-pressed", this._pressed)
  }
}

// ToastAutoDismiss: starts a client-side timer on mount and pushes a server
// event to remove the toast after the configured delay.
Hooks.ToastAutoDismiss = {
  mounted() {
    const delay = parseInt(this.el.dataset.autoDismiss || "5000", 10)
    if (delay > 0) {
      this._timer = setTimeout(() => {
        const id = this.el.dataset.toastId
        const event = this.el.dataset.onDismiss || "dismiss_toast"
        this.pushEvent(event, { id })
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

// SelectLabel: update label text on custom set-label event.
// beforeUpdate/updated preserve client-set text across LiveView patches —
// without these, morphdom would restore @selected_label from the last server render.
Hooks.SelectLabel = {
  mounted() {
    this._handler = (e) => {
      if (e.detail && e.detail.label) {
        this._label = e.detail.label
        this.el.textContent = e.detail.label
      }
    }
    this.el.addEventListener("set-label", this._handler)
  },
  beforeUpdate() {
    this._label = this._label || null
  },
  updated() {
    if (this._label) this.el.textContent = this._label
  },
  destroyed() {
    if (this._handler) this.el.removeEventListener("set-label", this._handler)
  }
}

// ToggleGroupSingle: enforces single-select semantics for role="radiogroup" toggle groups.
// When one toggle is pressed, all sibling toggles are unpressed.
Hooks.ToggleGroupSingle = {
  mounted() {
    this._onClick = (e) => {
      const btn = e.target.closest("button[aria-pressed]")
      if (!btn) return
      // Un-press all other toggles in the group
      this.el.querySelectorAll("button[aria-pressed]").forEach(other => {
        if (other !== btn) {
          other.setAttribute("aria-pressed", "false")
          other.setAttribute("data-state", "off")
        }
      })
    }
    this.el.addEventListener("click", this._onClick)

    // Arrow key navigation within the group (roving tabindex pattern)
    this._onKeyDown = (e) => {
      if (e.key !== "ArrowRight" && e.key !== "ArrowLeft") return
      const btns = Array.from(this.el.querySelectorAll("button[aria-pressed]:not([disabled])"))
      if (!btns.length) return
      const current = btns.indexOf(document.activeElement)
      if (current === -1) return
      e.preventDefault()
      let next
      if (e.key === "ArrowRight") next = (current + 1) % btns.length
      else next = (current - 1 + btns.length) % btns.length
      btns[next].focus()
    }
    this.el.addEventListener("keydown", this._onKeyDown)
  },
  destroyed() {
    if (this._onClick) this.el.removeEventListener("click", this._onClick)
    if (this._onKeyDown) this.el.removeEventListener("keydown", this._onKeyDown)
  }
}

// NavigationMenuNav: keyboard navigation for navigation menus.
// ArrowLeft/Right move between top-level triggers; ArrowDown/Enter opens
// the content panel and moves focus inside it; Escape closes and returns
// focus to the trigger.
Hooks.NavigationMenuNav = {
  mounted() {
    this._onKeyDown = (e) => {
      const triggers = Array.from(
        this.el.querySelectorAll('[data-nav-trigger]')
      )
      if (!triggers.length) return

      const activeTrigger = triggers.find(t =>
        t === document.activeElement ||
        t.closest("li")?.querySelector("[data-nav-content]")?.contains(document.activeElement)
      )
      const idx = activeTrigger ? triggers.indexOf(activeTrigger) : -1

      switch (e.key) {
        case "ArrowRight":
          if (idx === -1) break
          e.preventDefault()
          triggers[(idx + 1) % triggers.length].focus()
          break
        case "ArrowLeft":
          if (idx === -1) break
          e.preventDefault()
          triggers[(idx - 1 + triggers.length) % triggers.length].focus()
          break
        case "ArrowDown":
        case "Enter":
          if (document.activeElement && triggers.includes(document.activeElement)) {
            const expanded = document.activeElement.getAttribute("aria-expanded") === "true"
            if (!expanded) {
              // Open the panel
              document.activeElement.click()
            }
            // Move focus to first focusable item in content
            const itemId = document.activeElement.id.replace(/-trigger$/, "")
            const content = document.getElementById(itemId + "-content")
            if (content) {
              e.preventDefault()
              const first = content.querySelector('a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])')
              if (first) first.focus()
            }
          }
          break
        case "Escape": {
          // Close open content and return focus to its trigger
          const openContent = this.el.querySelector("[data-nav-content]:not(.hidden)")
          if (openContent) {
            e.preventDefault()
            e.stopPropagation()
            const itemId = openContent.id.replace(/-content$/, "")
            const backdrop = document.getElementById(itemId + "-backdrop")
            if (backdrop) backdrop.click()
            const trigger = document.getElementById(itemId + "-trigger")
            if (trigger) trigger.focus()
          }
          break
        }
      }
    }
    this.el.addEventListener("keydown", this._onKeyDown)
  },
  destroyed() {
    if (this._onKeyDown) this.el.removeEventListener("keydown", this._onKeyDown)
  }
}

// Slider: custom slider with tooltip, progress fill, hover preview, animated thumb
Hooks.Slider = {
  mounted() {
    this.track = this.el.querySelector("[data-slider-track]")
    this.thumb = this.el.querySelector("[data-slider-thumb]")
    this.fill = this.el.querySelector("[data-slider-fill]")
    this.hoverFill = this.el.querySelector("[data-slider-hover-fill]")
    this.tooltip = this.el.querySelector("[data-slider-tooltip]")
    this.tooltipValue = this.el.querySelector("[data-slider-tooltip-value]")
    this.input = this.el.querySelector("[data-slider-input]")

    this.min = parseFloat(this.el.dataset.min)
    this.max = parseFloat(this.el.dataset.max)
    this.step = parseFloat(this.el.dataset.step)
    this.value = parseFloat(this.el.dataset.value)
    this.dragging = false
    this.animating = false
    this.hovering = false

    // Enable transitions on thumb and fill for click-to-jump animation
    this._enableTransition = () => {
      this.thumb.style.transition = "left 0.35s cubic-bezier(0.25, 1, 0.5, 1)"
      this.fill.style.transition = "width 0.35s cubic-bezier(0.25, 1, 0.5, 1)"
      this.tooltip.style.transition = "left 0.35s cubic-bezier(0.25, 1, 0.5, 1), opacity 0.15s"
    }
    this._disableTransition = () => {
      this.thumb.style.transition = "none"
      this.fill.style.transition = "none"
      this.tooltip.style.transition = "opacity 0.15s"
    }

    // Mouse events on track for click-to-jump
    this.track.addEventListener("mousedown", (e) => {
      if (this._isDisabled()) return
      e.preventDefault()
      const val = this._valueFromEvent(e)
      this._enableTransition()
      this._setValue(val, true)
      // After animation, start drag mode so user can continue dragging
      this.animating = true
      this._animTimer = setTimeout(() => {
        this._animTimer = null
        this.animating = false
        this._disableTransition()
        this.dragging = true
      }, 350)
      this._addDragListeners()
    })

    // Mouse events on thumb for direct dragging
    this.thumb.addEventListener("mousedown", (e) => {
      if (this._isDisabled()) return
      e.preventDefault()
      e.stopPropagation()
      this.dragging = true
      this._disableTransition()
      this.thumb.style.cursor = "grabbing"
      this._showTooltip()
      this._addDragListeners()
    })

    // Touch events on track
    this.track.addEventListener("touchstart", (e) => {
      if (this._isDisabled()) return
      const touch = e.touches[0]
      const val = this._valueFromTouch(touch)
      this._enableTransition()
      this._setValue(val, true)
      this.animating = true
      this._animTimer = setTimeout(() => {
        this._animTimer = null
        this.animating = false
        this._disableTransition()
        this.dragging = true
      }, 350)
      this._addTouchListeners()
    }, { passive: true })

    // Touch events on thumb
    this.thumb.addEventListener("touchstart", (e) => {
      if (this._isDisabled()) return
      e.stopPropagation()
      this.dragging = true
      this._disableTransition()
      this._showTooltip()
      this._addTouchListeners()
    }, { passive: true })

    // Hover preview + tooltip
    this.track.addEventListener("mousemove", (e) => {
      if (this._isDisabled() || this.dragging) return
      this._updateHoverPreview(e)
      this._showTooltip()
    })
    this.track.addEventListener("mouseleave", () => {
      if (!this.dragging) {
        this._hideHoverPreview()
        this._hideTooltip()
      }
    })
    // Also show/hide tooltip when entering/leaving the thumb itself
    this.thumb.addEventListener("mouseenter", () => {
      if (!this._isDisabled() && !this.dragging) {
        this._hideHoverPreview()
        this._render()
        this._showTooltip()
      }
    })
    this.thumb.addEventListener("mouseleave", () => {
      if (!this.dragging && document.activeElement !== this.thumb) this._hideTooltip()
    })

    // Keyboard support on thumb
    this.thumb.addEventListener("keydown", (e) => {
      if (this._isDisabled()) return
      let newVal = this.value
      switch (e.key) {
        case "ArrowRight":
        case "ArrowUp":
          e.preventDefault()
          newVal = Math.min(this.max, this.value + this.step)
          break
        case "ArrowLeft":
        case "ArrowDown":
          e.preventDefault()
          newVal = Math.max(this.min, this.value - this.step)
          break
        case "Home":
          e.preventDefault()
          newVal = this.min
          break
        case "End":
          e.preventDefault()
          newVal = this.max
          break
        default:
          return
      }
      this._disableTransition()
      this._setValue(newVal, true)
    })

    // Show/hide tooltip on thumb focus
    this.thumb.addEventListener("focus", () => this._showTooltip())
    this.thumb.addEventListener("blur", () => {
      if (!this.dragging) this._hideTooltip()
    })
  },

  updated() {
    // Sync with server-pushed value changes
    const newVal = parseFloat(this.el.dataset.value)
    if (!this.dragging && newVal !== this.value) {
      this.value = newVal
      this._render()
    }
  },

  destroyed() {
    this._removeDragListeners()
    this._removeTouchListeners()
  },

  _isDisabled() {
    return this.el.dataset.disabled === "true"
  },

  _valueFromEvent(e) {
    const rect = this.track.getBoundingClientRect()
    const pct = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width))
    return this._snap(this.min + pct * (this.max - this.min))
  },

  _valueFromTouch(touch) {
    const rect = this.track.getBoundingClientRect()
    const pct = Math.max(0, Math.min(1, (touch.clientX - rect.left) / rect.width))
    return this._snap(this.min + pct * (this.max - this.min))
  },

  _snap(val) {
    const stepped = Math.round((val - this.min) / this.step) * this.step + this.min
    return Math.max(this.min, Math.min(this.max, parseFloat(stepped.toFixed(10))))
  },

  _pct(val) {
    return ((val - this.min) / (this.max - this.min)) * 100
  },

  _setValue(val, pushEvent) {
    this.value = val
    this._render()
    this.input.value = this._formatValue(val)
    if (pushEvent) {
      // Dispatch input event for phx-change forms
      this.input.dispatchEvent(new Event("input", { bubbles: true }))
    }
  },

  _formatValue(val) {
    return (this.step >= 1 && this.step === Math.trunc(this.step)) ? Math.trunc(val) : parseFloat(val.toFixed(2))
  },

  _render() {
    const pct = this._pct(this.value)
    this.thumb.style.left = pct + "%"
    this.fill.style.width = pct + "%"
    // Only update tooltip position/value if not showing a hover preview
    if (!this.hovering) {
      this.tooltip.style.left = pct + "%"
      if (this.tooltipValue) this.tooltipValue.textContent = this._formatValue(this.value)
    }
    this.thumb.setAttribute("aria-valuenow", this.value)
  },

  _showTooltip() {
    this.tooltip.style.opacity = "1"
  },

  _hideTooltip() {
    this.tooltip.style.opacity = ""
  },

  _updateHoverPreview(e) {
    this.hovering = true
    const rect = this.track.getBoundingClientRect()
    const rawPct = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width))
    const hoverPct = rawPct * 100
    const currentPct = this._pct(this.value)
    const hoverVal = this._snap(this.min + rawPct * (this.max - this.min))

    if (hoverPct > currentPct) {
      this.hoverFill.style.left = currentPct + "%"
      this.hoverFill.style.width = (hoverPct - currentPct) + "%"
    } else {
      this.hoverFill.style.left = hoverPct + "%"
      this.hoverFill.style.width = (currentPct - hoverPct) + "%"
    }
    this.hoverFill.style.opacity = "1"

    // Move tooltip to hover position and show hovered value
    this.tooltip.style.left = hoverPct + "%"
    if (this.tooltipValue) this.tooltipValue.textContent = this._formatValue(hoverVal)
  },

  _hideHoverPreview() {
    this.hovering = false
    this.hoverFill.style.opacity = "0"
    this.hoverFill.style.width = "0%"
    // Restore tooltip to current thumb value
    const pct = this._pct(this.value)
    this.tooltip.style.left = pct + "%"
    if (this.tooltipValue) this.tooltipValue.textContent = this._formatValue(this.value)
  },

  _addDragListeners() {
    this._onMouseMove = (e) => {
      if (!this.dragging && !this.animating) return
      if (this.animating) return
      const val = this._valueFromEvent(e)
      this._setValue(val, true)
      this._showTooltip()
      this._hideHoverPreview()
    }
    this._onMouseUp = () => {
      if (this._animTimer) { clearTimeout(this._animTimer); this._animTimer = null }
      this.dragging = false
      this.animating = false
      this._disableTransition()
      this.thumb.style.cursor = ""
      if (document.activeElement !== this.thumb) this._hideTooltip()
      this._hideHoverPreview()
      this._removeDragListeners()
    }
    document.addEventListener("mousemove", this._onMouseMove)
    document.addEventListener("mouseup", this._onMouseUp)
  },

  _removeDragListeners() {
    if (this._onMouseMove) document.removeEventListener("mousemove", this._onMouseMove)
    if (this._onMouseUp) document.removeEventListener("mouseup", this._onMouseUp)
  },

  _addTouchListeners() {
    this._onTouchMove = (e) => {
      if (!this.dragging && !this.animating) return
      if (this.animating) return
      const val = this._valueFromTouch(e.touches[0])
      this._setValue(val, true)
      this._showTooltip()
    }
    this._onTouchEnd = () => {
      if (this._animTimer) { clearTimeout(this._animTimer); this._animTimer = null }
      this.dragging = false
      this.animating = false
      this._disableTransition()
      this._hideTooltip()
      this._removeTouchListeners()
    }
    document.addEventListener("touchmove", this._onTouchMove, { passive: true })
    document.addEventListener("touchend", this._onTouchEnd)
  },

  _removeTouchListeners() {
    if (this._onTouchMove) document.removeEventListener("touchmove", this._onTouchMove)
    if (this._onTouchEnd) document.removeEventListener("touchend", this._onTouchEnd)
  }
}

// Global outside-click handler — closes non-modal overlays (popover, dropdown,
// combobox) when the user clicks outside the overlay root element.
// The backdrop is pointer-events-none so this is the sole click-outside path.
document.addEventListener("pointerdown", (e) => {
  // Walk escape-close backdrops in reverse DOM order (topmost last).
  const backdrops = Array.from(document.querySelectorAll("[data-escape-close]"))
  for (let i = backdrops.length - 1; i >= 0; i--) {
    const backdrop = backdrops[i]
    if (!isVisible(backdrop)) continue
    // Find the overlay root that owns this backdrop.
    const root = backdrop.closest(
      "[data-popover-root], [data-dropdown-root], [data-combobox-root], [data-select-root]"
    )
    if (!root) continue
    // Only close if the click landed outside the overlay root.
    if (!root.contains(e.target)) {
      backdrop.click()
      break
    }
  }
})

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

  // Alert dialogs must never be dismissed by Escape. If one is open, swallow
  // the event completely so it cannot leak to overlays behind the dialog.
  const openAlertDialog = Array.from(document.querySelectorAll('[role="alertdialog"]'))
    .find(el => isVisible(el))
  if (openAlertDialog) {
    e.stopPropagation()
    return
  }

  // Context menus (always close all, they sit on top of everything)
  let closedContext = false
  document.querySelectorAll("[data-context-menu-content]").forEach(el => {
    if (el.style.display === "block") {
      el.style.display = "none"
      closedContext = true
    }
  })
  if (closedContext) return

  // Find the last visible escape-close element (topmost in DOM order).
  // After clicking the backdrop, also reset aria-expanded on any associated
  // trigger so the attribute doesn't get stuck on "true".
  const escapeTargets = Array.from(document.querySelectorAll("[data-escape-close]"))
  for (let i = escapeTargets.length - 1; i >= 0; i--) {
    const target = escapeTargets[i]
    if (isVisible(target)) {
      target.click()
      // Reset aria-expanded on the nearest trigger within the same overlay root
      const root = target.closest("[data-popover-root], [data-dropdown-root], [data-combobox-root], [data-nav-item]")
      if (root) {
        root.querySelectorAll("[aria-expanded='true']").forEach(el => {
          el.setAttribute("aria-expanded", "false")
        })
      }
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

// Remove scroll lock left by an open modal/dialog when navigating away via LiveView.
// Both live_redirect (phx:navigate) and live_patch fire phx:page-loading-start,
// but we also listen to phx:navigate directly for cases where the topbar is disabled.
function clearScrollLock() {
  document.body.classList.remove("overflow-hidden")
}
window.addEventListener("phx:navigate", clearScrollLock)
window.addEventListener("phx:page-loading-start", clearScrollLock)

// On static hosting (GitHub Pages) there is no WebSocket server.
// Detect the x-static meta tag injected by mix docs.build and mount
// self-contained hooks directly instead of waiting for LiveSocket.
if (document.querySelector('meta[name="x-static"]')) {
  document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll("[phx-hook][id]").forEach(el => {
      const hookName = el.getAttribute("phx-hook")
      const hook = Hooks[hookName]
      if (!hook) return
      const inst = Object.assign(Object.create(hook), {
        el,
        pushEvent: () => {},
        pushEventTo: () => {},
        handleEvent: () => {},
      })
      try { inst.mounted?.() } catch (e) { /* hook may need LiveSocket, skip */ }
    })
  })
} else {
  liveSocket.connect()
}
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
