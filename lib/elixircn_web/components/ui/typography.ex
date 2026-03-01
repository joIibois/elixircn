defmodule ElixircnWeb.Components.UI.Typography do
  use Phoenix.Component

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def h1(assigns) do
    ~H"""
    <h1 class={["scroll-m-20 text-4xl font-extrabold tracking-tight lg:text-5xl", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h1>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def h2(assigns) do
    ~H"""
    <h2 class={["scroll-m-20 border-b pb-2 text-3xl font-semibold tracking-tight first:mt-0", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def h3(assigns) do
    ~H"""
    <h3 class={["scroll-m-20 text-2xl font-semibold tracking-tight", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def h4(assigns) do
    ~H"""
    <h4 class={["scroll-m-20 text-xl font-semibold tracking-tight", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h4>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def prose_p(assigns) do
    ~H"""
    <p class={["leading-7 [&:not(:first-child)]:mt-6", @class]} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def blockquote(assigns) do
    ~H"""
    <blockquote class={["mt-6 border-l-2 pl-6 italic", @class]} {@rest}>
      {render_slot(@inner_block)}
    </blockquote>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def inline_code(assigns) do
    ~H"""
    <code class={["relative rounded bg-muted px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold", @class]} {@rest}>{render_slot(@inner_block)}</code>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def lead(assigns) do
    ~H"""
    <p class={["text-xl text-muted-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def large_text(assigns) do
    ~H"""
    <div class={["text-lg font-semibold", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def small_text(assigns) do
    ~H"""
    <small class={["text-sm font-medium leading-none", @class]} {@rest}>
      {render_slot(@inner_block)}
    </small>
    """
  end

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def muted_text(assigns) do
    ~H"""
    <p class={["text-sm text-muted-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end
end
