<div align="center">
<img width="720" alt="the-scriptorium" src="_img/the-scriptorium.png">
</div>

# the-scriptorium

Lo scriptorium era la stanza dei monasteri dove si copiavano i manoscritti a
mano. Qui succede il contrario: sono gli script che ho scritto per non dover più
rifare a mano le stesse cose, divisi per ambito.

> Stato: raccolta di script personali, aggiornata quando serve. Le ultime aggiunte risalgono al 2023.

## certsnatcher/

- `JavaCertSnatcher.sh`: chiede un dominio, si collega sulla porta 443 con
  `openssl` e salva in una cartella datata il certificato del server (`.pem`),
  la catena completa (`_catena.pem`) e i relativi keystore Java (`.jks`, con
  password generata a caso), più un log dell'operazione. È la versione da riga
  di comando di [CertSnatcher](https://github.com/XtremeAlex/CertSnatcher).

## k8s/

Scorciatoie per `kubectl` quando cerchi un microservizio per nome. Prima di
usarle sostituisci `NAMESPACE` con il tuo namespace. Gli script usano `return`,
quindi vanno lanciati con `source` (per esempio `. kubectl_findLogsMsByName.sh nome-ms`).

| Script | Cosa fa |
|---|---|
| `kubectl_findAllPropsMsByName.sh <ms>` | stampa lo YAML di deployment, service e ingress del microservizio |
| `kubectl_findEnvMsByName.sh <ms>` | elenca le variabili d'ambiente del deployment |
| `kubectl_findLogsMsByName.sh <ms>` | segue i log del pod |
| `kubectl_getErrorMsbyName.sh <ms>` | segue i log del pod filtrando le righe `ERROR` |
| `kubectl_getAllError.sh` | cerca le righe `ERROR` nei log di tutti i pod del namespace |
| `kubectl_restartMsByName.sh <ms>` | riavvia il deployment (scala a 0 e poi a 1), poi mostra variabili d'ambiente e pod |
| `kubectl_findMsByName.sh <ms>` | al momento è identico a `kubectl_restartMsByName.sh`: riavvia, non si limita a cercare |

## Licenza
Distribuito sotto licenza Apache 2.0. Vedi il file [`LICENSE`](LICENSE) per i dettagli.

## Contatti

Andrei Alexandru Dabija (XtremeAlex) · [alexdabi92@gmail.com](mailto:alexdabi92@gmail.com) · [2ad.bubume.it](https://2ad.bubume.it/) · [LinkedIn](https://www.linkedin.com/in/andrei-alexandru-dabija/) · [github.com/XtremeAlex](https://github.com/XtremeAlex)
