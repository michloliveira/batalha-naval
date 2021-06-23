require "ruby2d"

class Computador
  attr_accessor :message, :message2, :messageOrientacaoNavio, :messageMudarOrientacao

  def initialize
    @computer = [] #array de objetos - quadrados
    @computerNavios = [] #array onde estará mapeado os navios
    @@tipos_navios = { 1 => "submarino", 3 => "navio_encouracado", 4 => "navio_de_guerra", 6 => "porta_avioes" }
    #Tabela de posicoes dos quadrados do tabuleiro, cada quadrado possui 50x50 ------------
    @positions = [[20, 100], [70, 100], [120, 100], [170, 100], [220, 100], [270, 100], [320, 100], [370, 100], [420, 100], [470, 100],
                  [20, 150], [70, 150], [120, 150], [170, 150], [220, 150], [270, 150], [320, 150], [370, 150], [420, 150], [470, 150],
                  [20, 200], [70, 200], [120, 200], [170, 200], [220, 200], [270, 200], [320, 200], [370, 200], [420, 200], [470, 200],
                  [20, 250], [70, 250], [120, 250], [170, 250], [220, 250], [270, 250], [320, 250], [370, 250], [420, 250], [470, 250],
                  [20, 300], [70, 300], [120, 300], [170, 300], [220, 300], [270, 300], [320, 300], [370, 300], [420, 300], [470, 300],
                  [20, 350], [70, 350], [120, 350], [170, 350], [220, 350], [270, 350], [320, 350], [370, 350], [420, 350], [470, 350],
                  [20, 400], [70, 400], [120, 400], [170, 400], [220, 400], [270, 400], [320, 400], [370, 400], [420, 400], [470, 400],
                  [20, 450], [70, 450], [120, 450], [170, 450], [220, 450], [270, 450], [320, 450], [370, 450], [420, 450], [470, 450],
                  [20, 500], [70, 500], [120, 500], [170, 500], [220, 500], [270, 500], [320, 500], [370, 500], [420, 500], [470, 500],
                  [20, 550], [70, 550], [120, 550], [170, 550], [220, 550], [270, 550], [320, 550], [370, 550], [420, 550], [470, 550]]

    @positions.each do |position| #preenchendo a computer com com os quadrados (objetos)
      @computer.push(Square.new(x: position[0] + 600, y: position[1], z: 0, size: 49, color: "#0F6A90"))
    end

    @coordenadas = Text.new(" A    B    C    D    E    F    G    H    I     J", size: 25, x: 625, y: 70)
  end

  def contains(x, y) #funcão que verifica se o click pertence a algum quadrado
    # p @computer
    @computer.each do |computer|
      if computer.contains?(x, y)
        computer.color = "red"
        return true
      end
    end
    return false
  end

  def getPosition(x, y) # função que retorna a o indice do quadrado clicado no array de quadrados
    @computer.each do |computer|
      if computer.contains?(x, y)
        #p @computer.find_index(computer)
        return @computer.find_index(computer)
      end
    end
  end

  # mudar o nome dessas funções

  def shipFits?(i, ship_size, orientacao)
    #compara o primeiro algarismo da posição onde começa o barco com o primeiro algarismo da posição onde ele termina.
    #se o segundo desses for maiosr, o barco termina em outra linha.
    # possui um caso especial para a primeira linha: se o fim do barco ficar em uma posição maior que 9, já vai estar em outra linha
    # verifica também se o fim do barco ultrapassaria a última posição
    fits_line_size_horizontal = !(((0..9) === i && i + (ship_size - 1) > 9) ||
                                  (!((0..9) === i) && (i + (ship_size - 1)).to_s[0].to_i > (i).to_s[0].to_i) ||
                                  i + (ship_size - 1) > 99)

    # verifica se o barco cabe na linha vertical proposta
    fits_line_vertical = i + ((ship_size - 1) * 10) <= 99

    is_range_free_horizontal = true
    is_range_free_vertical = true

    for j in 1..ship_size
      if containsShip?(i)
        orientacao == 0 ? is_range_free_horizontal = false : is_range_free_vertical = false
        break
      end
      orientacao == 0 ? i = i + 1 : i = i + 10
    end

    # dependendo da orientacao, se ambas as condições forem atendidas, o quadradinho escolhido pode abrigar o barco
    orientacao == 0 ? (fits_line_size_horizontal && is_range_free_horizontal) : (fits_line_vertical && is_range_free_vertical)
  end

  # recebe a posição que se pretende colocar o barco e o tamanho do barco
  # com base no tamanho do barco, ele já sabe quais imagens renderizar (array tipos_navios)
  def mapShip(i, ship_size, orientacao)
    # verifica se o quadrado clicado e seus sucessores podem abrigar o barco
    if shipFits?(i, ship_size, orientacao)
      # renderização das imagens nos quadradinhos
      # o 'j' serve para gerenciar qual parte do barco (imagem) será renderizada naquele determinado quadrado
      for j in 1..ship_size
        @computerNavios[i] = Image.new(
          "images/#{@@tipos_navios[ship_size]}_#{j}.png",
          x: @computer[i].x,
          y: @computer[i].y,
          width: 49, height: 49,
          opacity: 100,
        )

        orientacao == 0 ? @computerNavios[i].rotate = 0 : @computerNavios[i].rotate = 90
        @computer[i].color = "#87CEEB" # teste apenas; p/ destacar as casas escolhidas até o momento
        orientacao == 0 ? i = i + 1 : i = i + 10
      end
      return true
    else
      return false
    end
  end

  def hideShips
    @computer.each do |computer|
      computer.color = "#0F6A90"
      if containsShip?(@computer.find_index(computer))
        @computerNavios[@computer.find_index(computer)].opacity = 0
      end
    end
  end

  def containsShip?(i)
    !@computerNavios[i].nil?
  end

  def revealShip(i)
    boom = Sprite.new(
      "./images/boom.png",
      clip_width: 127,
      time: 75,
      width: 49,
      height: 49,
      x: @computer[i].x,
      y: @computer[i].y,
    )
    boom.play
    bomb = Sound.new("./audio/bomba.wav") # som de bomba quando acerta um barco
    bomb.play
    @computer[i].color = "white"
    @computerNavios[i].opacity = 100
  end

  def naoExisteNavio(i) # pintar o quadrado de vermelho e som de agua
    @computer[i].color = "red"
    agua = Sound.new("./audio/boom_water.wav")
    agua.play
  end

  def won?
    won = true
    @computer.each do |computer|
      # se uma posição contem um barco mas esse barco ainda tem opacidade 0, essa parte do barco ainda não foi encontrada
      # e, assim, o jogador não ganhou
      if containsShip?(@computer.find_index(computer)) && @computerNavios[@computer.find_index(computer)].opacity == 0
        won = false
      end
    end
    won
  end
end
