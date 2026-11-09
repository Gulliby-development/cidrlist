defmodule Cidrlist.Nets do
  @moduledoc false

  # Reading of one address or network word, size and last address of a block.
  def parse_address(text) do
    case String.split(text, ".") do
      [_, _, _, _] = parts ->
        nums = Enum.map(parts, &number(&1, 255, 3))

        if :bad in nums do
          :bad
        else
          {:ok, Enum.reduce(nums, 0, fn n, acc -> acc * 256 + n end)}
        end

      _ ->
        :bad
    end
  end

  def parse_net(word) do
    case String.split(word, "/") do
      [addr] -> build(parse_address(addr), 32)
      [addr, len] -> build(parse_address(addr), number(len, 32, 2))
      _ -> :bad
    end
  end

  def size(len), do: Integer.pow(2, 32 - len)

  def last(first, len), do: first + size(len) - 1

  defp build({:ok, first}, len) when is_integer(len) do
    if rem(first, size(len)) == 0, do: {:ok, first, len}, else: :host_bits
  end

  defp build(_, _), do: :bad

  defp number(text, max, digits) do
    if byte_size(text) in 1..digits and Regex.match?(~r/\A[0-9]+\z/, text) and
         (text == "0" or not String.starts_with?(text, "0")) do
      n = String.to_integer(text)
      if n <= max, do: n, else: :bad
    else
      :bad
    end
  end
end
