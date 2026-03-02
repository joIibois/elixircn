# elixircn

A port of [shadcn/ui](https://ui.shadcn.com) to [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view). 59 components built as Phoenix function components, styled with Tailwind v4.

**[View the showcase →](https://joIibois.github.io/elixircn)**

---

## Using the registry

Components are distributed via a shadcn-compatible registry. You copy exactly what you need into your project — no package to install.

### Prerequisites

- Phoenix LiveView app
- [Tailwind v4](https://tailwindcss.com/blog/tailwindcss-v4) configured (CSS-first, no `tailwind.config.js`)
- `shadcn` CLI: `npm install -g shadcn@latest` (or use `npx`)

### Add a component

```bash
npx shadcn@latest add https://joIibois.github.io/elixircn/r/button.json
```

This copies the component file to `lib/my_app_web/components/ui/button.ex`, with your app's module namespace already substituted.

Components with dependencies (e.g. `alert-dialog` depends on `button`) will automatically install them too.

### Register it globally

After installing, import the component in the `html_helpers` function in your `my_app_web.ex`:

```elixir
defp html_helpers do
  quote do
    # ... existing imports ...
    import MyAppWeb.Components.UI.Button
  end
end
```

Now `<.button>` is available in all your templates and LiveViews without any per-file imports.

---

## JS Hooks

Some components require a LiveView JavaScript hook. After installing one of these, copy the corresponding hook from [`assets/js/app.js`](assets/js/app.js) into your own `app.js`:

| Component     | Hook            |
|---------------|-----------------|
| `carousel`    | `Carousel`      |
| `combobox`    | `ComboboxFilter`|
| `context-menu`| `ContextMenu`   |
| `input-otp`   | `InputOtp`      |
| `resizable`   | `Resizable`     |

Register the hook in your `liveSocket` setup:

```js
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { Carousel, ComboboxFilter, ContextMenu, InputOtp, Resizable },
  // ...
})
```

---

## Dark mode

Components support dark mode via a `data-theme="dark"` attribute on the `<html>` element. Toggle it with:

```heex
<button phx-click={JS.toggle_attribute({"data-theme", "dark"}, to: "html")}>
  Toggle dark mode
</button>
```

---

## All components

```
accordion         alert             alert-dialog      aspect-ratio
avatar            badge             breadcrumb        button
button-group      calendar          card              carousel
checkbox          collapsible       combobox          command
context-menu      data-table        date-picker       dialog
direction         drawer            dropdown-menu     empty
field             hover-card        icon              input
input-group       input-otp         item              kbd
label             menubar           native-select     navigation-menu
pagination        popover           progress          radio-group
resizable         scroll-area       select            separator
sheet             sidebar           skeleton          slider
spinner           switch            table             tabs
textarea          toast             toggle            toggle-group
tooltip           typography
```

---

## Development

```bash
mix setup        # install deps
mix phx.server   # start at http://localhost:4000

mix registry.build   # rebuild docs/r/ registry JSON
```

---

Built by [Jacob Jolibois](https://x.com/jacobjolibois) at [IngredientAI](https://www.ingredient-ai.com/).
