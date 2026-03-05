# elixircn

A port of [shadcn/ui](https://ui.shadcn.com) to [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view). 59 components built as Phoenix function components, styled with Tailwind v4.

**[View the showcase →](https://joIibois.github.io/elixircn)**

---

## Using the registry

Components are distributed via a shadcn-compatible registry. You copy exactly what you need into your project — no package to install.

### Prerequisites

- Phoenix LiveView app
- [Tailwind v4](https://tailwindcss.com/blog/tailwindcss-v4) configured (CSS-first, no `tailwind.config.js`)
- [`tw_merge`](https://github.com/bluzky/tw_merge) — Tailwind class conflict resolution (see below)
- `shadcn` CLI: `npm install -g shadcn@latest` (or use `npx`)

### Resolve CoreComponents conflicts

> **Do this first.** Phoenix 1.8 generates `button/1`, `input/1`, `icon/1`, and `table/1` in `CoreComponents`. Elixircn exports the same names. Without this step you'll get cryptic "ambiguous function call" compilation errors.

**Option A — run the installer (recommended):**

```bash
mix elixircn.install
```

This auto-detects your `*_web.ex` file and adds the `except` clause for you.

**Option B — patch manually:**

In your `my_app_web.ex`, find the `import YourAppWeb.CoreComponents` line inside `html_helpers/0` and add the `except` list:

```elixir
import MyAppWeb.CoreComponents, except: [input: 1, icon: 1, button: 1, table: 1]
```

#### What to exclude — and what to keep

Only exclude the four names that conflict. Do **not** remove the entire `CoreComponents` import or exclude everything — several functions there have no elixircn replacement:

| Function | Action | Reason |
|---|---|---|
| `button/1` | **exclude** | replaced by elixircn `button` |
| `input/1` | **exclude** | replaced by elixircn `input` |
| `icon/1` | **exclude** | replaced by elixircn `icon` |
| `table/1` | **exclude** | replaced by elixircn `table` |
| `flash/1` | **keep** | renders `put_flash/2` notices — no elixircn replacement |
| `show/2` | **keep** | JS helper used by `flash/1` and your own templates |
| `hide/2` | **keep** | JS helper used by `flash/1` and your own templates |
| `translate_error/1` | **keep** | required for form error translation |
| `translate_errors/2` | **keep** | required for form error translation |
| `header/1`, `list/1` | **keep** | page-layout helpers with no elixircn equivalent |

If you exclude `flash/1`, `show/2`, or `hide/2`, flash messages will silently stop working — they won't raise a compile error because `Phoenix.Component` provides its own `show`/`hide` JS wrappers, but the animated transitions and flash dismissal will break.

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

### Configure Tailwind to scan your components

Components use Tailwind classes, so Tailwind must scan your web module directory. In `assets/css/app.css`, add a `@source` line pointing to your app's web module folder:

```css
@source "../../lib/my_app_web";
```

Replace `my_app_web` with your actual web module directory name (e.g. `my_app_web`, `my_company_web`, etc.). Without this, Tailwind won't see the classes used in component files and they will be stripped from the build.

---

## Tailwind Merge

Components use a `cn()` utility (the Elixir equivalent of shadcn/ui's `cn()`) to merge Tailwind classes with conflict resolution. This is powered by [`tw_merge`](https://github.com/bluzky/tw_merge).

Add the dependency to your `mix.exs`:

```elixir
defp deps do
  [
    {:tw_merge, "~> 0.1"},
    # ...
  ]
end
```

Then run `mix deps.get`.

The `cn()` function is installed automatically as `utils.ex` when you add your first component via the registry. It handles class merging so that later classes override earlier ones when they target the same CSS property:

```elixir
cn(["px-4 py-2", "px-6"])
#=> "py-2 px-6"

cn(["bg-red-500", condition && "bg-blue-500", @class])
#=> merges with conflict resolution, filters out falsy values
```

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
