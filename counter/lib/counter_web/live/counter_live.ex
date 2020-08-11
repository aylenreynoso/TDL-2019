defmodule CounterWeb.CounterLive do
  use CounterWeb, :live_view

  def mount(_param, _ , socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <h1> The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    """
  end

  def handle_event("inc", _value, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _value, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end
end
