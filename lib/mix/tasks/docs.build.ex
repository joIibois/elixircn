defmodule Mix.Tasks.Docs.Build do
  @shortdoc "Generate static HTML for GitHub Pages"
  use Mix.Task

  @out "docs"
  @base_path "/elixircn"

  @components ~w(
    accordion alert alert-dialog aspect-ratio avatar badge breadcrumb button
    button-group calendar card carousel checkbox collapsible combobox command
    context-menu data-table date-picker dialog direction drawer dropdown-menu
    empty field hover-card input input-group input-otp item kbd label menubar
    native-select navigation-menu pagination popover progress radio-group
    resizable scroll-area select separator sheet sidebar skeleton slider
    spinner switch table tabs textarea toast toggle toggle-group tooltip
    typography
  )

  def run(_args) do
    configure_endpoint()
    Mix.Task.run("app.start")

    pages = [{"", "/"} | Enum.map(@components, &{&1, "/#{&1}"})]

    IO.puts("Building #{length(pages)} pages → #{@out}/")
    File.mkdir_p!(@out)

    for {slug, path} <- pages do
      html = render(path)
      dir = if slug == "", do: @out, else: Path.join(@out, slug)
      File.mkdir_p!(dir)
      File.write!(Path.join(dir, "index.html"), html)
      IO.puts("  ✓ #{path}")
    end

    copy_assets()
    File.write!(Path.join(@out, ".nojekyll"), "")

    IO.puts("Done.")
  end

  # Set the URL path prefix before app.start so ~p"" helpers emit /elixircn/...
  defp configure_endpoint do
    existing = Application.get_env(:elixircn, ElixircnWeb.Endpoint, [])
    url = existing |> Keyword.get(:url, []) |> Keyword.put(:path, @base_path)

    Application.put_env(
      :elixircn,
      ElixircnWeb.Endpoint,
      existing
      |> Keyword.put(:url, url)
      |> Keyword.put(:server, false)
      |> Keyword.put(:code_reloader, false)
    )
  end

  defp render(path) do
    conn =
      Plug.Test.conn(:get, path)
      |> Plug.Conn.put_req_header("accept", "text/html")

    conn = ElixircnWeb.Endpoint.call(conn, [])

    conn.resp_body
    |> inject_static_meta()
    |> strip_live_reload()
  end

  # JS uses this meta tag to skip LiveSocket and mount hooks directly
  defp inject_static_meta(html) do
    String.replace(
      html,
      "</head>",
      ~s(<meta name="x-static" content="true">\n</head>),
      global: false
    )
  end

  # Remove Phoenix LiveReloader script injected in dev mode
  defp strip_live_reload(html) do
    Regex.replace(~r/<!-- Phoenix LiveReload.*?<\/script>/s, html, "")
  end

  defp copy_assets do
    for dir <- ~w(assets images fonts) do
      src = Path.join("priv/static", dir)
      if File.exists?(src), do: File.cp_r!(src, Path.join(@out, dir))
    end
  end
end
