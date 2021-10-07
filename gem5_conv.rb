

syms = []
File.open("nm.out") { |f|
  f.each { |line|
    a = line.split
    unless a[2] =~ /^\$/
      syms << [a[0].to_i(16), a[2]]
    end
  }
}

syms.sort! {|x,y| x[0] <=> y[0]}

prev = [""]
ARGF.each { |line|
  arr = line.split
  if arr[2] == "T0"
    t = arr[0]
    iaddr_s = arr[4]
    iaddr = iaddr_s.to_i(16)
    curr = syms.bsearch {|v| v[0] > iaddr}
    label = curr[1]
    #p prev
    if prev[-2] == label
      prev.pop()
      space = " " * (prev.size - 1)
      puts "#{t} #{iaddr_s} #{space} #{label}"
    end
    if prev.last != label
      space = " " * prev.size
      #puts "#{iaddr_s} #{space} #{label}      #{prev.join("  +  ")}"
      puts "#{t} #{iaddr_s} #{space} #{label}"
      prev.append(label)
    end
  end
}
