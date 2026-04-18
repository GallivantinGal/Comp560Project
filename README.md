# Spear Guy Survival

**Spear Guy Survival** is a 2D single-boss, souls-like game where you face a powerful spear-wielding enemy in a fast-paced combat encounter. Your goal is to survive and defeat the boss using timing, positioning, and smart attack choices.

## How to Play

You control a knight fighting a large spear boss. Combat is timing-based, so avoid spamming attacks without thinking.

### Controls
- **A / D** → Move  
- **Spacebar** → Jump  
- **E** → Slash Up  
- **Double Tap E** → Slash Down
- **E while moving** → Running Slash    
- **Spam E** → Cycles through basic slash combo  
- **Q** → Thrust  
- **Shift** → Block  

## Boss Attacks
- **Attack 1:** 360° swipe that hits all around the boss  
- **Attack 2:** Charge thrust toward the player  
- **Attack 3:** Charge thrust upward diagonally
- **Attack 3:** Counter shield that disables your block for 2 seconds  

## Boss AI
The boss improves over time using **Monte Carlo Tree Search (MCTS)**. It starts with random moves, then repeats successful attack patterns, making it progressively more difficult.

## Objective
Defeat the boss while managing your attacks and defense. Learn patterns, react carefully, and survive.

## Project Context
This game was developed as a final project for COMP 560, focusing on combat mechanics, input handling, and an adaptive AI-driven boss encounter.
