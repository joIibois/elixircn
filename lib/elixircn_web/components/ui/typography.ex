defmodule ElixircnWeb.Components.UI.Typography do
  @moduledoc "Provides styled typography components for headings, paragraphs, and text elements."
  use Phoenix.Component
  import ElixircnWeb.Components.UI.Utils

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a styled h1 heading with large bold tracking-tight text."
  def h1(assigns) do
    ~H"""
    <h1 class={cn(["scroll-m-20 text-4xl font-extrabold tracking-tight lg:text-5xl", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h1>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a styled h2 heading with a bottom border and semibold text."
  def h2(assigns) do
    ~H"""
    <h2
      class={cn(["scroll-m-20 border-b pb-2 text-3xl font-semibold tracking-tight first:mt-0", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a styled h3 heading with semibold tracking-tight text."
  def h3(assigns) do
    ~H"""
    <h3 class={cn(["scroll-m-20 text-2xl font-semibold tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a styled h4 heading with semibold tracking-tight text."
  def h4(assigns) do
    ~H"""
    <h4 class={cn(["scroll-m-20 text-xl font-semibold tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h4>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a prose paragraph with standard leading and top margin on subsequent paragraphs."
  def prose_p(assigns) do
    ~H"""
    <p class={cn(["leading-7 [&:not(:first-child)]:mt-6", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a styled blockquote with left border and italic text."
  def blockquote(assigns) do
    ~H"""
    <blockquote class={cn(["mt-6 border-l-2 pl-6 italic", @class])} {@rest}>
      {render_slot(@inner_block)}
    </blockquote>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders an inline code element with monospace font and muted background."
  def inline_code(assigns) do
    ~H"""
    <code
      class={cn([
        "relative rounded bg-muted px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold",
        @class
      ])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </code>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a lead paragraph with larger muted-foreground text."
  def lead(assigns) do
    ~H"""
    <p class={cn(["text-xl text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a div with large semibold text styling."
  def large_text(assigns) do
    ~H"""
    <div class={cn(["text-lg font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a small element with small medium leading-none text."
  def small_text(assigns) do
    ~H"""
    <small class={cn(["text-sm font-medium leading-none", @class])} {@rest}>
      {render_slot(@inner_block)}
    </small>
    """
  end

  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @doc "Renders a paragraph with small muted-foreground text."
  def muted_text(assigns) do
    ~H"""
    <p class={cn(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end
end
