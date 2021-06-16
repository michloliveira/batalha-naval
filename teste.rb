require "ruby2d"
set background: "navy"
set width: 1155, height: 600
class Grid
    def initialize
        @player1 = [] #array de objetos - quadrados
        @player1Navios = [] #array onde estará mapeado os navios
        #Tabela de posicoes dos quadrados do tabuleiro, cada quadrado possui 50x50 ------------
        @positions = [[0,0],[50,0],[100,0],[150,0],[200,0],[250,0],[300,0],[350,0],[400,0],[450,0],
                     [0,50],[50,50],[100,50],[150,50],[200,50],[250,50],[300,50],[350,50],[400,50],[450,50],
                     [0,100],[50,100],[100,100],[150,100],[200,100],[250,100],[300,100],[350,100],[400,100],[450,100],
                     [0,150],[50,150],[100,150],[150,150],[200,150],[250,150],[300,150],[350,150],[400,150],[450,150],
                     [0,200],[50,200],[100,200],[150,200],[200,200],[250,200],[300,200],[350,200],[400,200],[450,200],
                     [0,250],[50,250],[100,250],[150,250],[200,250],[250,250],[300,250],[350,250],[400,250],[450,250],
                     [0,300],[50,300],[100,300],[150,300],[200,300],[250,300],[300,300],[350,300],[400,300],[450,300],
                     [0,350],[50,350],[100,350],[150,350],[200,350],[250,350],[300,350],[350,350],[400,350],[450,350],
                     [0,400],[50,400],[100,400],[150,400],[200,400],[250,400],[300,400],[350,400],[400,400],[450,400],
                     [0,450],[50,450],[100,450],[150,450],[200,450],[250,450],[300,450],[350,450],[400,450],[450,450]]

        @positions.each do |position| #preenchendo a player1 com com os quadrados (objetos)
            @player1.push(Square.new(x: position[0], y: position[1],z: 0,size: 45, color: 'blue'))
        end

        @player1Navios.push(Image.new( #preenchendo o array de navios com um submarino teste
            'images/sub.png',
            x: 0, y: 0,
            width: 50, height: 50,
            z: -1
          ))
    end

    def contains(x,y) #funcão que verifica se o click pertence a algum quadrado
       # p @player1
        @player1.each do |player1|
            if player1.contains?(x,y)
                player1.color = 'red'
                player1.z = -5  
            end

        end
    end
end

#----------------------------------------------------------------------
tabuleiro = Grid.new

on :mouse_down do |event|
    puts event.x, event.y #apenas printa a posição do mouse no click
    tabuleiro.contains(event.x,event.y)
end

show