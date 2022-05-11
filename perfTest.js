import http from 'k6/http';
import { check } from 'k6';

const domain = "http://localhost:8080";
const singleInsertUrl = domain+"/calculator/insert";
const multipleInsertUrl = domain+'/calculator/insertMultiple';
const rakeDb = domain+'/calculator/rakeDatabase';

const single = JSON.parse(open('./json/single.json'));
const multiple = JSON.parse(open('./json/multiple.json'));

export const options = {
    vus: 10,
    duration: '1s',
  };

export default function () {
  const payload = JSON.stringify(single)

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const res = http.post(singleInsertUrl, payload, params);
  check(res,{"status is 202": (r) => r.status == 202})
}