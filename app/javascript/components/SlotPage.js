import React, { useState } from "react";

const SlotPage = () => {
  const [date, setDate] = useState("");
  const [time, setTime] = useState("");
  const [list, setList] = useState([]);

  // ------------- GET

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

  // -------------- PUT
  const [duration, setDuration] = useState("");

  const bookDurationSlot = (duration) => {
    let mounted = true;
    bookSlot(duration).then(() => {
      if (mounted) {
        console.log(duration, "duration");
      }
    });
    return () => (mounted = false);
  };

  const bookSlot = (duration) => {
    return fetch(
      `http://localhost:3000/slots?start_date=${duration.start_time}&end_date=${duration.end_time}`,
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((data) => data.json())
      .catch((error) => {
        console.log("Error:", error);
      });
  };

  const handleSlotSelection = (e) => {
    e.preventDefault();
    bookDurationSlot(duration);
    showSuccessNotification();
  };

  const showSuccessNotification = () => {
    
  }

  // ------------

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
        <form
          onSubmit={(e) => {
            handleSlotSelection(e);
          }}
        >
          <div>
            <h1>Available Slot List </h1>
            <h3>Please select a slot 👇 </h3>
            <ul>
              {list.map((item, index) => (
                <button
                  key={index}
                  index={index}
                  onClick={() => setDuration(item)}
                >
                  {formatDate(item.start_time)} - {formatDate(item.end_time)}
                </button>
              ))}
            </ul>
          </div>
        </form>
      )}
    </div>
  );
};
export default SlotPage;
