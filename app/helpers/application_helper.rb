module ApplicationHelper
  
  def  hoge(collection)
      diff = collection.open_diff
      if diff.to_i >= 3  
        "3日経過"
      elsif diff.to_i >= 1 
        "1日経過"
      else
        "開栓当日"
      end
  end
end
