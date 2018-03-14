import java.util.InputMismatchException;
import java.util.Scanner;

public class Game {
    public static void main(String[] args) {
        int player=1;

        Board game = new Board();
        for(int i=0; i<8; i++)
            System.out.print(" ");
        System.out.print("MANCALA");
        for(int i=0; i<8; i++)
            System.out.print(" ");
        System.out.println("\n");

        while(true){
            game.printBoard();
            System.out.println();
            int slotPick = readInput(player, game);

            Boolean playAgain = game.move(slotPick*(3-player*2)+(player-1)*14);

            if(game.totalOnSide(1)==0 || game.totalOnSide(2)==0) {
                game.cleanUp();
                game.printBoard();
                break;
            }

            if(!playAgain)
                player = player%2+1;
        }
        if(game.playerScore(1)>game.playerScore(2)) {
            System.out.println("Player 1 wins!");
        } else if(game.playerScore(1)<game.playerScore(2)) {
            System.out.println("Player 2 wins!");
        } else {
                System.out.println("Draw!");
        }

    }

    public static int readInput(int player, Board board) {
        Scanner reader = new Scanner(System.in);
        System.out.print("\nPlayer " + player + "'s turn. ");
        int in=1;
        while(true) {
            try {
                System.out.print("Pick a slot: ");
                in = reader.nextInt();
                if(in<1 || in>6 || board.numAt(in*(3-player*2)+(player-1)*14)==0)
                    throw new InputMismatchException();
                break;
            } catch (InputMismatchException e) {
                System.out.println("You have to pick a non-empty slot from 1 to 6");
                reader = new Scanner(System.in);
            }
        }
        return in;
    }
}
