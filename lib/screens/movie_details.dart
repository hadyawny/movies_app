import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/models/movie_details_model.dart';
import 'package:movies_app/models/movie_model.dart';
import 'package:movies_app/utils/fonts.dart';
import 'package:movies_app/viewmodels/movie_details_view_model.dart';
import 'package:movies_app/widgets/home_tab_widgets/movie_card.dart';
import 'package:movies_app/widgets/movie_details_card.dart';
import 'package:provider/provider.dart';

class MovieDetails extends StatefulWidget {
  Results args;

  MovieDetails(this.args, {super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  MovieDetailsViewModel viewModel = MovieDetailsViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.args.title.toString(),
            style: fontSmall.copyWith(fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 520.h,
              child: FutureBuilder(
                future: viewModel.getMovieDetails(widget.args.id.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  MovieDetailsModel movieDetailsModel = snapshot.data!;

                  return MovieDetailsCard(
                    results: widget.args,
                    movieDetailsModel: movieDetailsModel,
                  );
                },
              ),
            ),
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      "More Like This",
                      style: fontSmall.copyWith(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  FutureBuilder(
                    future:
                        viewModel.getSemilarMovies(widget.args.id.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      List<Results> similar = snapshot.data!.results ?? [];

                      return Expanded(
                        child: ListView.builder(
                          itemCount: similar.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return MovieCard(
                              results: similar[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
