import React, { useState } from "react";
import { formatDate, formatResponse } from "../services/utils";
import { bookSlot } from "../services/SlotApi";

const SlotBooking = (props) => {
  const [duration, setDuration] = useState("");

  const bookDurationSlot = (duration) => {
    let mounted = true;
    bookSlot(duration).then(() => {
      if (mounted) {
        formatResponse(duration);
        props.getDurationSlots(props.date, props.time);
      }
    });
    return () => (mounted = false);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    bookDurationSlot(duration);
  };

  return (
    <div>
      {props.list.length !== 0 && (
        <form
          onSubmit={(e) => {
            handleSubmit(e);
          }}
        >
          <div>
            <h1>Available Slot List </h1>
            <h3>Please select a slot 👇 </h3>
            <ul>
              {props.list.map((item, index) => (
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
export default SlotBooking;
