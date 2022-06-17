states <- list(
  AK = "Alaska",
  AL = "Alabama",
  AR = "Arkansas",
  AS = "American Samoa",
  AZ = "Arizona",
  CA = "California",
  CO = "Colorado",
  CT = "Connecticut",
  DC = "District of Columbia",
  DE = "Delaware",
  FL = "Florida",
  FSM = "Federated States of Micronesia",
  GA = "Georgia",
  GU = "Guam",
  HI = "Hawaii",
  IA = "Iowa",
  ID = "Idaho",
  IL = "Illinois",
  IN = "Indiana",
  KS = "Kansas",
  KY = "Kentucky",
  LA = "Louisiana",
  MA = "Massachusetts",
  MD = "Maryland",
  ME = "Maine",
  MI = "Michigan",
  MN = "Minnesota",
  MO = "Missouri",
  MP = "Northern Mariana Islands",
  MS = "Mississippi",
  MT = "Montana",
  NC = "North Carolina",
  ND = "North Dakota",
  NE = "Nebraska",
  NH = "New Hampshire",
  NJ = "New Jersey",
  NM = "New Mexico",
  NV = "Nevada",
  NY = "New York",
  NYC = "New York City",
  OH = "Ohio",
  OK = "Oklahoma",
  OR = "Oregon",
  PA = "Pennsylvania",
  PR = "Puerto Rico",
  PW = "Palau",
  RI = "Rhode Island",
  RMI = "Republic of the Marshall Islands",
  SC = "South Carolina",
  SD = "South Dakota",
  TN = "Tennessee",
  TX = "Texas",
  UT = "Utah",
  VA = "Virginia",
  VI = "Virgin Islands",
  VT = "Vermont",
  WA = "Washington",
  WI = "Wisconsin",
  WV = "West Virginia",
  WY = "Wyoming"
)

danger_states <- c("CA", "FL", "TX", "NYC", "NY")
warning_states <- c("NJ", "NC", "IL", "OH", "PA")
normal_states <- setdiff(names(states), c(danger_states, warning_states))


df <- vroom::vroom(
  "United_States_COVID-19_Cases_and_Deaths_by_State_over_Time.csv.gz",
  col_types = vroom::cols_only(
    submission_date = vroom::col_date("%m/%d/%Y"),
    state = "c",
    new_case = "d",
    new_death = "d"
  )
)

weekly_df <- df |>
  mutate(submission_date = lubridate::floor_date(submission_date, unit = "week")) |>
  group_by(state, submission_date) |>
  summarise(new_case = sum(new_case), new_death = sum(new_death),
    .groups = "drop"
  )
