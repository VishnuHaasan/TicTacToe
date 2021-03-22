class Player
  @@player_count ||= 0;
  attr_reader :has_player_won,:name,:symbol
  def initialize(name)
    @name = name;
    @@player_count+=1;
    if @@player_count%2==0
      @symbol = "O"
    else  
      @symbol = "X"
    end
    @movement = Array.new;
    @has_player_won = false;
    @number_of_movements = 0;
    @hash_y = {0 => 0,1 => 0,2 => 0};
    @hash_x = {0 => 0,1 => 0,2 => 0};
  end
  def makeMovement(temp)
    @movement.push(temp);
    @hash_x[temp[0]]+=1;
    @hash_y[temp[1]]+=1;
    @number_of_movements+=1;
    checkIfWon;
  end
  private
  def checkHash
    @hash_x.each do |x,y|
      return true if y>=3
    end
    @hash_y.each do |x,y|
      return true if y>=3
    end
    return false
  end
  def checkForCross
    if @movement.include?([0,0]) && @movement.include?([1,1]) && @movement.include?([2,2])
      return true
    elsif @movement.include?([2,0]) && @movement.include?([1,1]) && @movement.include?([0,2])
      return true
    end
    return false
  end
  def checkIfWon
    if @number_of_movements<3
      return false
    end
    if checkHash
      @has_player_won = true
      return @has_player_won 
    elsif checkForCross
      @has_player_won = true
      return @has_player_won
    end
  end
  def self.gameEnds
    @@player_count = 0;
  end
end

#End of class.

def objectCreator
  puts "Player 1,enter your name: "
  p1 = gets.chomp
  puts "Player 2,enter your name: "
  p2 = gets.chomp
  x = rand
  if x > 0.5
    selector = [Player.new(p2),Player.new(p1)]
  else
    selector = [Player.new(p1),Player.new(p2)]
  end
  puts "#{selector[0].name.capitalize} has been chosen by the gods of computing to play as X and #{selector[1].name.capitalize} has been chosen to play as O"
  return selector
end
def printScore(array)
  puts
  for i in 0..2 do
    for j in 0..2 do
      if j == 0
        print " " + array[i][j].to_s + " | "
        next
      end
      if j == 2
        puts array[i][j].to_s 
        next
      end
      print array[i][j].to_s + " | "
    end
    next if i == 2
    puts "---+---+--- "
  end
  puts
end
def winAnnouncement(name)
  puts "#{name} has won the match."
end
def conversion(n)
  a = Array.new
  case n 
  when 1 then a = [0,0]
  when 2 then a = [0,1]
  when 3 then a = [0,2]
  when 4 then a = [1,0]
  when 5 then a = [1,1]
  when 6 then a = [1,2]
  when 7 then a = [2,0]
  when 8 then a = [2,1]
  when 9 then a = [2,2]
  end
  return a 
end
def printLayout
  puts
  k = 1
  for i in 1..3 do
    for j in 1..3 do
      if j == 1
        print " " + k.to_s + " | "
        k+=1
        next
      end
      if j == 3
        puts k.to_s 
        next
      end
      print k.to_s + " | "
      k+=1
    end
    next if i == 3
    puts "---+---+--- "
  end
  puts
end
def getMovement(array,obj)
  puts "Chance for #{obj.symbol} to enter"
  puts "Enter your position based on the layout above: "
  n = gets.chomp.to_i
  a = conversion(n)
  i = a[0]
  j = a[1]
  until array[i][j].is_a? Integer do
    puts "The position is already occupied"
    puts "Chance for #{obj.symbol} to enter"
    puts "Enter your position based on the layout above: "
    n = gets.chomp
    a = conversion(n)
    i = a[0]
    j = a[1]
  end
  array[i][j] = obj.symbol
  return [i,j]
end
def playRound
  array = [[1,2,3],[4,5,6],[7,8,9]]
  spa = objectCreator
  p1 = spa[0]
  p2 = spa[1]
  i = 1
  puts p1.symbol
  puts p2.symbol
  while !p1.has_player_won && !p2.has_player_won && i<=4 do
    p1.makeMovement(getMovement(array,p1))
    printScore(array)
    if p1.has_player_won
      puts "#{p1.name} has won"
      break
    end
    p2.makeMovement(getMovement(array,p2))
    if p2.has_player_won
      puts "#{p2.name} has won"
      break
    end
    i+=1
    printScore(array)
  end
  if !p1.has_player_won && !p2.has_player_won
    p2.makeMovement(getMovement(array,p2))
    if p2.has_player_won
      puts "#{p2.name} has won"
    end
  end
  printScore(array)
  puts "Match has drawn." if !p1.has_player_won && !p2.has_player_won
end
flag = false
puts "The layout is: "
printLayout;
print "Can we start the game[y/n]: "
starter = gets.chomp
flag = true if starter == "y"
while flag
  playRound
  puts "Do you want to play again[y/n]: "
  starter = gets.chomp
  if starter == "y"
    flag = true
  else 
    flag = false
  end
end
puts "The game is over see you later."



