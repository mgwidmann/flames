import moment from 'moment-timezone';
moment.tz.guess();

export function incidentTimestamp(timestamp) {
  return moment.utc(timestamp).local().format('MMMM Do YYYY, h:mm:ss a');
}
