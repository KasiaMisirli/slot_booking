import React, { useState } from "react";

const SlotPage = () => {
  const [date, setDate] = useState("");
  const [time, setTime] = useState("");
  const [list, setList] = useState([]);

  const getDurationSlots = () => {
    let mounted = true;
    getList(date, time).then((items) => {
      if (mounted) {
        setList(items);
      }
    });
    return () => (mounted = false);
  };

  const getList = (date, time) => {
    return fetch(
      `http://localhost:3000/slots?date=${date}T00:00:00+00:00&minutes=${time}`
    ).then((data) => data.json());
  };

  const formatDate = (date) => {
    let time_selected = date.slice(11, 16);
    return time_selected;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    getDurationSlots(date, time);
  };

  return (
    <div>
      <h1>Slot Booking App</h1>
      <form
        onSubmit={(e) => {
          handleSubmit(e);
        }}
      >
        <label>
          Select date between 1st of January 2022 and 28th of February 2022 and
          duration in minutes
          <input type="date" onChange={(e) => setDate(e.target.value)} />
          <input
            type="input"
            pattern="[+-]?\d+(?:[.,]\d+)?"
            placeholder="Enter time in minutes"
            onChange={(e) => setTime(e.target.value)}
          />
        </label>
        <input type="submit" value="Submit" />
      </form>
      {list.length !== 0 && (
        <div>
          <h1>Available Slot List</h1>
          <ul>
            {list.map((item, index) => (
              <li key={index} index={index}>
                {formatDate(item.start_time)} - {formatDate(item.end_time)}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};
export default SlotPage;
