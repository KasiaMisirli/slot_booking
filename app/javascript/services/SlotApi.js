export const getList = (date, time) => {
  return fetch(
    `http://localhost:3000/slots?date=${date}T00:00:00+00:00&minutes=${time}`
  ).then((data) => data.json());
};

export const bookSlot = (duration) => {
  return fetch(
    `http://localhost:3000/slots?start_date=${duration.start_time}&end_date=${duration.end_time}`,
    {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
    }
  ).then((data) => data.json());
};
