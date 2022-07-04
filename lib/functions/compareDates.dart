class CompareDate {
  //check d1 is after d2
  static bool compareDates(DateTime d1,DateTime d2){
    if(d1.year>d2.year)
      return true;
    if(d1.month>d2.month)
      return true;
    if(d1.month==d2.month && d1.day>d2.day)
      return true;
    return false;
  }
}