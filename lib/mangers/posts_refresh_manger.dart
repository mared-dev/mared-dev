import 'package:paginate_firestore/bloc/pagination_listeners.dart';

class PostsRefreshManger {
  static PaginateRefreshedChangeListener feedRefreshChangeListener =
      PaginateRefreshedChangeListener();

  static refreshFeedPosts() {
    feedRefreshChangeListener.refreshed = true;
  }
}
