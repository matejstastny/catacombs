package catacombs.objects;

import catacombs.util.TerminalUtil;

public class GameMap {

    private final int WIDTH = 10;
    private final int HEIGHT = 10;

    private final String PLAYER_COLOR = TerminalUtil.Ansi.BG_MAGENTA;

    private int playerX = 0;
    private int playerY = 0;

    private TileType[][] mapData;

    // ---------------------------

    public GameMap() {
        mapData = new TileType[WIDTH][HEIGHT];
        generateMap();
    }

    public void render() {
        for (int y = 0; y < HEIGHT; y++) {
            for (int x = 0; x < WIDTH; x++) {
                if (x == playerX && y == playerY) {
                    System.out.print(PLAYER_COLOR + " P " + TerminalUtil.Ansi.RESET);
                } else if (mapData[x][y] == TileType.WALL) {
                    System.out.print(" " + wallChar(x, y) + " ");
                } else {
                    System.out.print(" " + mapData[x][y] + " ");
                }
            }
            System.out.println();
        }
    }

    public void setPlayerPosition(int x, int y) {
        if (x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT) {
            playerX = x;
            playerY = y;
        } else {
            throw new IllegalArgumentException("Player position out of bounds");
        }
    }

    public void movePlayer(int dx, int dy) {
        int newX = playerX + dx;
        int newY = playerY + dy;
        if (newX >= 0 && newX < WIDTH && newY >= 0 && newY < HEIGHT) {
            playerX = newX;
            playerY = newY;
        }
    }

    // ---------------------------

    private void generateMap() {
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < HEIGHT; y++) {
                if (x == 0 || x == WIDTH - 1 || y == 0 || y == HEIGHT - 1) {
                    mapData[x][y] = TileType.WALL;
                } else {
                    mapData[x][y] = TileType.EMPTY;
                }
            }
        }
    }

    private char wallChar(int x, int y) {
        // char corner1 = middle ? '├' : top ? '┌' : '└';
        // char corner2 = middle ? '┤' : top ? '┐' : '┘';
        // char divider = middle ? '┼' : top ? '┬' : '┴';
        assert x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT;
        return '#'; // TODO
    }

    // ---------------------------

    public enum TileType {
        EMPTY(" "), WALL("#");

        private final String symbol;

        TileType(String symbol) {
            this.symbol = symbol;
        }

        @Override
        public String toString() {
            return symbol;
        }

        TileType() {
            this.symbol = " ";
        }
    }

}
