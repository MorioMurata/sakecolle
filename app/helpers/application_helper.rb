module ApplicationHelper

  def how_long_time_elapse(collection)
    #after_open_timeメソッドについてはcollection.rbモデル内に定義
    time_elapse = collection.after_open_time
    if time_elapse.to_i >= 31
      "1ヶ月経過！！！"
    elsif time_elapse.to_i >= 7
      "1週間経過！！"
    elsif time_elapse.to_i >= 3
      "3日経過！"
    elsif time_elapse.to_i >= 1
      "1日経過"
    else
      "開栓当日"
    end
  end

  def over_eighty_percent_of_stock_capacity(collection, user)
    #quantity_of_collections＝残量ステータスが"完飲"になっていない投稿の総数。
    quantity_of_collections = collection.where.not(remain_amount: "finish").count
    #users_capacity＝ユーザー指定の在庫上限の８割。calculate_capacityメソッドについてはuser.rbモデル内に定義。
    users_capacity = user.calculate_capacity
    #完飲前の在庫数が上限の８割に達していたらアラート表示。
    if quantity_of_collections >= users_capacity
      "ストック上限の８割に達しました！"
    end
  end
end
