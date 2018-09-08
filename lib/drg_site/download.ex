defmodule DrgSite.Download do
  def getChecksum(filename) do
    filenameLength = String.length(filename)
    filenameLength = if(filenameLength < 10)do "0#{filenameLength}" else "#{filenameLength}" end
    key = curentTime() <> filenameLength
    cycle = elem(Integer.parse(to_string(getRandom())), 0) - 1
    key = Enum.reduce(0..cycle, "#{curentTime()}#{filenameLength}", fn x, acc ->
      y = rem x, 2
      if(y != 0) do
        leftMove(acc)
      else
        rightMove(acc)
      end
    end)
    String.slice(key, 0, 4) <> to_string(cycle + 1) <> String.slice(key, 4, 4)
  end

  defp curentTime() do
    {_, {hour, minute, second}} = :calendar.local_time()
    hour = if(hour < 10)do "0#{hour}" else hour end
    minute = if(minute < 10)do "0#{minute}" else minute end
    second = if(second < 10)do "0#{second}" else second end
    "#{hour}#{minute}#{second}"
  end

  defp getRandom() do
    #拿到时间6位数字转换字符串
    x = curentTime()
    #为了增大随机性,把秒放到前面
    x = String.reverse(x)
    #拿到时间整数
    x= Integer.parse(x)
    x = elem(x, 0)
    #乘以5位小数拿到类似随机数*10的数
    # IO.inspect x
    x = x * 0.00001
    cond do
      x < 5 -> 5
      x < 1 -> 1
      true -> x
    end
  end

  defp leftMove(str) do
    lenstr = String.length(str)
    result = Enum.reduce(0..lenstr, %{:right => "", :left => ""}, fn x, acc ->
      %{:right => right, :left => left} = acc
      if((rem x, 2) != 0) do
        %{acc | :right => "#{right}#{String.slice(str, x, 1)}"}
      else
        %{acc | :left => "#{left}#{String.slice(str, x, 1)}"}
      end
    end)
    "#{result.left}#{result.right}"
  end

  defp rightMove(str) do
    lenstr = String.length(str)
    result = Enum.reduce(0..lenstr, %{:right => "", :left => ""}, fn x, acc ->
      %{:right => right, :left => left} = acc
      if((rem x, 2) != 0) do
        %{acc | :left => "#{left}#{String.slice(str, x, 1)}"}
      else
        %{acc | :right => "#{right}#{String.slice(str, x, 1)}"}
      end
    end)
    "#{result.left}#{result.right}"
  end
end
