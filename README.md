# UserFS  

## Descriere  
Acest proiect constă într-un script shell care gestionează informațiile despre utilizatorii activi dintr-un sistem, oferind o reprezentare structurată și o actualizare periodică a acestora.  

## Funcționalități  

### 1. Reprezentarea utilizatorilor activi  
- Fiecare utilizator activ din sistem este reprezentat printr-un director propriu.  
- În interiorul acestui director se află un fișier numit `procs`, care listează procesele curente ale utilizatorului.  

### 2. Organizarea într-un director rădăcină  
- Toate directoarele care conțin informații despre utilizatorii activi sunt grupate într-un director comun numit **director rădăcină**.  

### 3. Actualizare periodică  
- Informațiile despre utilizatorii activi sunt actualizate automat la fiecare **30 de secunde**.  
- Dacă un utilizator devine inactiv, directorul corespunzător rămâne, dar:  
  - Fișierul `procs` devine gol.  
  - Este creat un fișier suplimentar numit `lastlogin`, care afișează data ultimei sesiuni a utilizatorului.  

### 4. Raport zilnic  
Scriptul generează un raport zilnic care include:  
- **Numărul total de utilizatori activi** în ziua respectivă.  
- **Cele mai utilizate procese.**  
- **Cei mai activi utilizatori.**  
- **Utilizatorii cu activități suspecte**, cum ar fi:  
  - Rularea unor procese specifice.  
  - Un număr foarte mare de procese active.  

## Utilizare  
- Scriptul poate fi folosit pentru monitorizarea activității utilizatorilor dintr-un sistem și pentru detectarea anomaliilor.  
- Structura și periodicitatea actualizării sunt configurabile pentru a răspunde nevoilor specifice.  
