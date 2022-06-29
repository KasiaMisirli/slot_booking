export const formatDate = (date) => {
  let time_selected = date.slice(11, 16);
  return time_selected;
};

export const formatResponse = (duration) => {
  let day = duration.start_time.slice(0, 10);
  window.alert(
    "You have successfully booked a delivery slot on " +
      day +
      " between " +
      formatDate(duration.start_time) +
      " and " +
      formatDate(duration.end_time)
  );
};
