require "ruby2d"

# preencher por iteração
@tabuleiro = [[], [], [], [], [], [], [], [], [], []]

for i in 0..9
  for j in 0..9
    @tabuleiro[i][j] = 0
  end
end

def print_grid
  for i in 0..9
    for j in 0..9
      print @tabuleiro[i][j].to_s + " "
    end
    puts
  end
  puts
end

# Set the window size
set width: 1155, height: 674

set title: "Batalha naval", background: "#c68c53"

# método pra verificar se um click foi dentro do grid principal da tela
def click_inner_grid?(event)
  if ((182..706) === event.x && (69..588) === event.y)
    true
  else
    false
  end
end

# método que retorna qual foi a posição clicada no grid principal da tela
def click_which_tile(event)
  x = 706 - event.x
  y = 586 - event.y

  # tá invertido (??)
  [10 - (x / 52) - 1, 10 - (y / 52) - 1]
end

# método pra preencher a matriz com a posição do click (arrumar)
def map_click_on_grid(x, y)
  @tabuleiro[x][y] = 1
end

on :mouse_down do |event|
  #puts "posicão array: [" + click_which_tile(event)[1].to_s + "][" + click_which_tile(event)[0].to_s + "]"
  map_click_on_grid(click_which_tile(event)[1], click_which_tile(event)[0])
  print_grid
end

Image.new("./images/background.png")

show
