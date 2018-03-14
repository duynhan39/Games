import java.util.ArrayList;

public class Board {
    ArrayList<Slot> board;

    Board() {
        this.board = new ArrayList<Slot>(14);
        for(int i=0; i<14; i++) {
            this.board.add(new Slot());
        }

        this.board.get(0).emptySlot();
        this.board.get(7).emptySlot();
    }

    public Boolean move(int slotNum) {
        int temNum = board.get(slotNum).getNum();
        board.get(slotNum).emptySlot();

        for(int i=1; i <= temNum; i++){
            board.get((slotNum+i)%14).add(1);
        }

        if((slotNum+temNum)%7 != 0 && board.get((slotNum+temNum)%14).getNum() == 1) {
            capture((slotNum+temNum)%14);
        }

        if((slotNum+temNum)%7==0)
            return true;
        return false;
    }

    public void capture(int slotNum) {
        board.get(slotNum).emptySlot();
        board.get(14-slotNum).emptySlot();
        board.get(slotNum/7).add(board.get(slotNum).getNum() + board.get(14-slotNum).getNum());
    }

    public void printBoard() {
        printEnd(1);

        for (int i=1; i<7; i++) {
            printSlot(i);
        }

        printEnd(2);

    }

    public void printEnd(int playerNum) {
        int temNum = board.get((playerNum-1)*7).getNum();
        String horizontalLine = new String(new char[18]).replace('\0', '-');

        System.out.println(String.format("P%d:%d%-5s%s", playerNum, board.get((playerNum-1)*7).getNum(), " ", horizontalLine));

        for(int i=0; i<3; i++) {
            if(temNum>16) {

                temNum -= 16;
                System.out.println(String.format("%-8s| OOOOOOOOOOOOOOOO |", ""));

            } else {

                System.out.print(String.format("%-8s| ", ""));
                for(int j=0; j<temNum; j++)
                    System.out.print("O");
                for(int j=0; j<17-temNum; j++)
                    System.out.print(" ");
                System.out.println("|");
                temNum=0;

            }
        }
        System.out.println(String.format("%-9s%s", "", horizontalLine));
    }

    public void printSlot(int Line) {
        String horizontalLine = new String(new char[18]).replace('\0', '-');
        System.out.println(String.format("%-9s%s", "", horizontalLine));

        int temNum1 = board.get(Line).getNum();
        int temNum2 = board.get(14-Line).getNum();
        int tem = temNum2;

        System.out.print(String.format(" %-2d%-2s%-3d", Line, "|", temNum1));

        temNum1 = printSLotLine(temNum1);
        temNum2 = printSLotLine(temNum2);
        System.out.println(" "+tem);

        for(int i=1; i<3; i++) {
            System.out.print(String.format("%-8s", ""));

            temNum1 = printSLotLine(temNum1);
            temNum2 = printSLotLine(temNum2);

            System.out.println();
        }

        System.out.println(String.format("%-9s%s", "", horizontalLine));
    }

    public int printSLotLine(int temNum) {
        if(temNum>8) {

            temNum -= 8;
            System.out.print("|OOOOOOOO|");

        } else {

            System.out.print("|");
            for(int j=0; j<temNum; j++)
                System.out.print("O");
            for(int j=0; j<8-temNum; j++)
                System.out.print(" ");
            System.out.print("|");
            temNum=0;

        }
        return temNum;
    }

    public int totalOnSide(int player) {
        int sum=0;
        for(int i=(player-1)*7+1; i<player*7; i++)
            sum += board.get(i).getNum();
        return sum;
    }

    public void cleanUp() {
        board.get(0).add(totalOnSide(1));
        board.get(0).add(totalOnSide(2));
        for(int i=1; i<=6; i++) {
            board.get(i).emptySlot();
            board.get(14-i).emptySlot();
        }
    }

    public int playerScore(int player) {
        return board.get((player-1)*7).getNum();
    }

    public int numAt(int slotNum) {
        return board.get(slotNum).getNum();
    }
}
