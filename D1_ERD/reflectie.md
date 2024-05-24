Milestone 1: Onderwerp en Git
---

Student:
--------
Arthur Linsen

Onderwerp: (veel op veel)
-------------------------
- M:N
    - Member - Exercise
    - Fitness - Member


- 2Level: Fitness
    - Machine
    - Exercise


Entiteittypes:
--------------
- Fitness
- Member
- Exercise
- Machine

Relatietypes:
-------------
- Fitness
  - has 
  - Machine
  - has 
  - Member
- Member
  - goes to
  - Fitness
  - does
  - Exercise
- Exercise
  - performed by
  - Member
  - is done on
  - Machine
- Machine
  - being used for
  - Exercise
  - is placed in
  - Fitness

Attributen:
-----------
- Fitness
    - name
    - email
    - street
    - street number
    - postal code
    - surface
- Member
  - name
  - birth date
  - email
  - gender
  - bodyweight
- Exercise
    - name
    - muscle group
    - added weight
    - difficulty
    - instruction
- Machine
    - name
    - max weight
    - instruction
    - price
    - weight
    - brand