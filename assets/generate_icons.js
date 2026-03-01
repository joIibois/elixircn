#!/usr/bin/env node
/**
 * Generates lib/elixircn_web/components/ui/icon.ex from lucide-static SVG files.
 * Run: node assets/generate_icons.js
 */

const fs = require("fs")
const path = require("path")

const ICONS_DIR = path.join(__dirname, "node_modules/lucide-static/icons")
const OUTPUT_FILE = path.join(__dirname, "../lib/elixircn_web/components/ui/icon.ex")

// Icons to include — add more as needed
const ICONS = [
  "calendar",
  "check",
  "chevron-down",
  "chevron-left",
  "chevron-right",
  "chevrons-down-up",
  "chevrons-up-down",
  "circle-x",
  "copy",
  "download",
  "ellipsis",
  "external-link",
  "file",
  "file-edit",
  "file-text",
  "github",
  "grip-vertical",
  "grid-2x2",
  "info",
  "layout-grid",
  "log-out",
  "monitor",
  "moon",
  "search",
  "settings",
  "square-pen",
  "sun",
  "user",
  "users",
  "x",
]

/**
 * Extracts the inner content of an SVG (everything between <svg ...> and </svg>)
 * and normalizes whitespace to a single line.
 */
function extractSvgInner(svgContent) {
  // Remove the HTML comment
  let content = svgContent.replace(/<!--.*?-->/gs, "")
  // Remove the outer <svg ...> opening tag
  content = content.replace(/<svg[^>]*>/s, "")
  // Remove the closing </svg>
  content = content.replace(/<\/svg>/, "")
  // Normalize whitespace: collapse all whitespace sequences to a single space
  content = content.replace(/\s+/g, " ").trim()
  return content
}

// Build the clauses
const clauses = ICONS.map((name) => {
  const filePath = path.join(ICONS_DIR, `${name}.svg`)
  if (!fs.existsSync(filePath)) {
    console.error(`  ✗ Missing: ${name}.svg`)
    process.exit(1)
  }
  const raw = fs.readFileSync(filePath, "utf8")
  const inner = extractSvgInner(raw)
  return `  defp icon_svg("${name}"), do: ~s(${inner})`
})

const elixirModule = `defmodule ElixircnWeb.Components.UI.Icon do
  use Phoenix.Component

  attr :name, :string, required: true
  attr :class, :string, default: "h-4 w-4"
  attr :rest, :global

  def icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      class={@class}
      {@rest}
    >
      {Phoenix.HTML.raw(icon_svg(@name))}
    </svg>
    """
  end

${clauses.join("\n")}
end
`

fs.writeFileSync(OUTPUT_FILE, elixirModule)
console.log(`Generated ${OUTPUT_FILE} with ${ICONS.length} icons.`)
