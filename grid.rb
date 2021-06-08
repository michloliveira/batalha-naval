require "ruby2d"

# classe para representar o grid
class Grid < Window
  attr_accessor :boom, :boom_sound
  attr_reader :background

  def draw_grid
    set title: "Batalha naval", background: "#c68c53"
    set width: 1155, height: 674

    $background = Image.new("./images/background.png")

    # from https://www.ruby2d.com/learn/sprites/
    $boom = Sprite.new(
      "./images/boom.png",
      clip_width: 127,
      time: 75,
    )

    $boom_sound = Sound.new("./audio/boom_water.wav")
  end

  def click_inner_grid?(event)
    if ((182..706) === event.x && (69..588) === event.y)
      true
    end
  end

  def board_position_clicked(event)
    x = 706 - event.x
    y = 586 - event.y

    [10 - (x / 52) - 1, 10 - (y / 52) - 1]
  end

  def clicked
    # mudar posição da sprint p/ ficar no quadrado clicado
    $boom.play
    $boom_sound.play

    #colocar aqui chamada p/ outros métodos

  end
end
