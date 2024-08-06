CREATE TABLE leaderboard (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(50) NOT NULL,
    length FLOAT NOT NULL,
    caught_time DATETIME NOT NULL
);