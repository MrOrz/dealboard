module DealHelper
  def dealer_delay(s)
    case s
      when "N"
        return "", 0
      when "E"
        return "<td></td>", 1
      when "S"
        return "<td></td><td></td>", 2
      when "W"
        return "<td></td><td></td><td></td>", 3
    end
  end

  def suit(s)
    return case s
    when /^\dC/
      s.split("")[0].to_s + '<span class="suitsymbol">♣</span>'
    when /^\dD/
      s.split("")[0].to_s + '<span class="suitsymbol red">♦</span>'
    when /^\dH/
      s.split("")[0].to_s + '<span class="suitsymbol red">♥</span>'
    when /^\dS/
      s.split("")[0] + '<span class="suitsymbol">♠</span>'
    when /^\dN/
      s.split("")[0].to_s + "NT"
    when /P/
      "Pass"
    when /XX/
      "Rdbl"
    when /X/
      "Dbl"
    end
  end
end

