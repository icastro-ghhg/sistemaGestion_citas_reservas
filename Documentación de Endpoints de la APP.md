Documentación de Endpoints de la API



Esta es la documentación de los endpoints de la API REST (https://api.sebastian.cl/vote) que son consumidos por la aplicación, desde el archivo VotesRepository.dart.


Autenticación: Todas las peticiones requieren un header de autorización con un token JWT. En esta implementación, se utiliza un token estático que se carga al inicio de la aplicación.


Authorization: Bearer <JWT\_ESTÁTICO>


1\. Encuestas (Polls)

1.1 Listar Encuestas

Endpoint: GET /v1/polls/

Descripción: Devuelve una lista paginada de todas las encuestas disponibles. Permite filtrado y búsqueda.

Parámetros de Query:

page (int, opcional): Número de página a solicitar.

pageSize (int, opcional): Cantidad de resultados por página.

q (String, opcional): Término de búsqueda para filtrar encuestas por nombre.

filters (Map<String, String>, opcional): Otros filtros aplicables.

Respuesta Exitosa (200 OK): Un array de objetos de encuesta.

\[

  {

    "token": "e8d5f1c2-4b3a-4d09-ae3a-1e5b8a6d2f12",

    "name": "Encuesta de satisfacción 2026",

    "active": true,

    "owner": false

  }

]

1.2 Obtener Detalle de una Encuesta

Endpoint: GET /v1/polls/{voteId}

Descripción: Devuelve la información completa de una encuesta específica, incluyendo sus opciones.


Parámetros de Path:

voteId (String, requerido): El token único de la encuesta (referido como pollToken en otras partes de la API).
Respuesta Exitosa (200 OK): Un objeto de encuesta con detalles.

{

  "token": "e8d5f1c2-...",

  "name": "Encuesta de satisfacción 2026",

  "description": "...",

  "active": true,

  "owner": false,

  "options": \[

    { "selection": 1, "choice": "Opción A" }

  ]

}

2\. Votación (Vote)

2.1 Registrar un Voto

Endpoint: POST /v1/vote/election

Descripción: Registra el voto de un usuario en una opción de una encuesta específica.

Cuerpo de la Petición (Request Body):

{

  "pollToken": "e8d5f1c2-...",

  "selection": 1

}

Respuesta Exitosa (200 OK): Cuerpo vacío.

Respuesta de Error (500): La aplicación interpreta este código como que el usuario "Ya ha votado en esta encuesta".



2.2 Obtener Resultados de una Encuesta
Endpoint: GET /v1/vote/{pollToken}/results
Descripción: Devuelve los resultados agregados (conteo de votos) para cada opción de una encuesta.

Parámetros de Path:
pollToken (String, requerido): El token único de la encuesta.
Respuesta Exitosa (200 OK): Un objeto con el nombre y los resultados de la encuesta.

{

  "name": "Encuesta de satisfacción 2026",

  "results": \[

    { "choice": "Opción A", "total": 42 }

  ]

}

3\. Historial de Usuario
Endpoints: La aplicación intenta secuencialmente las siguientes rutas para obtener el historial del usuario:
GET /v1/me/votes
GET /v1/users/me/votes (Fallback)
Descripción: Devuelve una lista de las encuestas en las que ha participado el usuario autenticado.
Respuesta Exitosa (200 OK): Un array de objetos de encuesta, similar a la respuesta de GET /v1/polls/.

