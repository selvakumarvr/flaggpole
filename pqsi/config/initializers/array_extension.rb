class Array
  def nitems
    count {|i| !i.nil?}
  end
end