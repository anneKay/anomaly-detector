# README

This service helps users to better understand irregularities in their data. The solution is built on top of the Z-Score peak detection algorithm(originally proposed by Jean-Paul van Brakel) which calculates for each data point to know if it deviates from a moving average by a given threshold, if so, it is then flagged as a peak.

`0` indicates no peak in the series
`1` indicates maximum
`-1` indicates minimum

* How to run the app
- Run rails s

Make a POST request to `v1/data-signals` endpoint with the following params;
params:
  - `threshold` : `3`
  - `data` : `[1,1.1,0.9,1,1,1.2,2.5,2.3,2.4,1.1,0.8,1.2,1]`

you should get a sample response as follows;

```
{
  "signal": [0,0,0,0,0,0,1,1,1,0,0,0,0]
}
```
* How to run the test suite
- Run rspec spec

* External libraries Used
- `Rspec` for testing
- `Rubocop` for linting
- `enumerable-statistics` for calculating statistical values like mean and standard deviation

* Additional Information
- It took me around 4-5 hours to come up with this solution

* Possible Future Improvements
- Handle dataset from an events stream with tools such as Kafka that enables rapid and scalable ingestion of streaming data
- Implement a notification system that alerts users when an anomaly is detected
