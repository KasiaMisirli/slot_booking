import React, { useState } from "react";
import { getList } from "../services/SlotApi";
import SlotBooking from "../components/SlotBooking";

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
            placeholder="Enter time in minutes"
            onChange={(e) => setTime(e.target.value)}
          />
        </label>
        <input type="submit" value="Submit" />
      </form>
      <SlotBooking
        list={list}
        getDurationSlots={getDurationSlots}
        date={date}
        time={time}
      />
    </div>
  );
};
export default SlotPage;
