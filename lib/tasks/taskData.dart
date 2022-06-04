class TaskData {
    final int? index;
    final String title;
    final String description;
    final bool reached;
    final int score;

    const TaskData(this.index,this.title, this.description, int reach, this.score):reached=(reach==1)?true:false;

}