defmodule P2pNeighbour do

  def generateNeighbourMap(localId, numNodes, idList, levels, neighbourMap) do
    if(numNodes > 0) do
      x = Enum.at(idList, numNodes - 1)
      if (x == localId) do
        generateNeighbourMap(localId, numNodes - 1, idList, levels, neighbourMap)
      else
        neighbourMaps = generateNeighbourMapHelper(localId, x, levels, 0, neighbourMap)
        generateNeighbourMap(localId, numNodes - 1, idList, levels, neighbourMaps)
      end
    else
      neighbourMap
    end
  end

  def generateNeighbourMapHelper(root, numToBeChecked, digit, level, neighbourMap) do
    if(digit > 0) do
      if String.at("#{numToBeChecked}", level) == String.at("#{root}", level) do
        neighbourMaps =
        if is_nil(Map.get(neighbourMap, {level, String.at("#{numToBeChecked}", level)})) do
           Map.put(neighbourMap,{level, String.at("#{numToBeChecked}", level)}, numToBeChecked)
        else
          if(abs(String.to_integer(Map.get(neighbourMap, {level, String.at("#{numToBeChecked}", level)}), 16) - String.to_integer(root, 16)) > abs(String.to_integer(numToBeChecked, 16) - String.to_integer(root, 16))) do
            Map.put(neighbourMap, {level, String.at("#{numToBeChecked}", level)}, numToBeChecked)
          else
            neighbourMap
          end
        end
        generateNeighbourMapHelper(root, numToBeChecked, digit - 1, level + 1, neighbourMaps)
      else
        if is_nil(Map.get(neighbourMap, {level, String.at("#{numToBeChecked}", level)})) do
           Map.put(neighbourMap,{level, String.at("#{numToBeChecked}", level)}, numToBeChecked)
        else
          if(abs(String.to_integer(Map.get(neighbourMap, {level, String.at("#{numToBeChecked}", level)}), 16) - String.to_integer(root, 16)) > abs(String.to_integer(numToBeChecked, 16) - String.to_integer(root, 16))) do
            Map.put(neighbourMap, {level, String.at("#{numToBeChecked}", level)}, numToBeChecked)
          else
            neighbourMap
          end
        end
      end
    else
      neighbourMap
    end
  end
end
