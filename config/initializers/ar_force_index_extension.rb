class ActiveRecord::Base
  def use_index(index)
    from("#{table_name} USE INDEX(#{index})")
  end

  def force_index(index)
    from("#{table_name} FORCE INDEX(#{index})")
  end
end
