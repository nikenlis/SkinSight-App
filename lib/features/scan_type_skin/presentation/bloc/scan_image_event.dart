part of 'scan_image_bloc.dart';

sealed class ScanImageEvent extends Equatable {
  const ScanImageEvent();

  @override
  List<Object> get props => [];
}

class GetScanImageEvent extends ScanImageEvent {
   final File image;

  const GetScanImageEvent({required this.image});
}