CREATE DATABASE worldcup;

CREATE TABLE IF NOT EXISTS teams (
  team_id SERIAL PRIMARY KEY,
  name character varying(40) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS games (
  game_id SERIAL PRIMARY KEY,
  year INT NOT NULL,
  round VARCHAR(255) NOT NULL,
  winner_id INT NOT NULL,
  opponent_id INT NOT NULL,
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL,
  CONSTRAINT fk_winner FOREIGN KEY (winner_id) REFERENCES teams(team_id),
  CONSTRAINT fk_opponent FOREIGN KEY (opponent_id) REFERENCES teams(team_id)
);

ALTER TABLE teams 
ALTER COLUMN team_id SET NOT NULL;

ALTER TABLE games 
ALTER COLUMN game_id SET NOT NULL;

INSERT INTO teams (name) VALUES 
('Argentina'), ('Brazil'), ('Germany'), ('Spain'), 
('France'), ('Italy'), ('Uruguay'), ('England'), 
('Netherlands'), ('Portugal'), ('Sweden'), ('Hungary'), 
('Czech Republic'), ('Austria'), ('Switzerland'), 
('Belgium'), ('Poland'), ('Russia'), ('Mexico'), 
('Chile'), ('Colombia'), ('United States'), 
('Romania'), ('Yugoslavia');

--Eliminar filas de tablas
--TRUNCATE TABLE games, teams;

--Eliminar tablas
--DROP TABLE IF EXISTS teams, games;
