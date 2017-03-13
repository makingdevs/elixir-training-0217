defmodule Twinder.User.Visualization do
  alias Graphvix.{Graph, Node, Edge, Cluster}

  def show_interactions(interactions) do
    Graph.new(:interactions)
    interactions
    |> create_graph
    Graph.save
    Graph.compile(:png)
  end

  defp create_graph(interactions) do
    interactions
    |> Enum.each(fn {u1, _interaction, u2} ->
      {node1_id, _node} = Node.new(label: u1)
      {node2_id, _node} = Node.new(label: u2)
      {edge_id, _edge} = Edge.new(node1_id, node2_id)
    end)
  end

end
