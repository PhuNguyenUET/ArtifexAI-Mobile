// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_state.dart';

// **************************************************************************
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

mixin _$ProjectState {
  GenerationMode get mode;
  GenerationModel get generationModel;
  bool get generating;
  bool get done;
  ImageResponseDto? get result;
  VideoResponseDto? get videoResult;
  String? get error;
  List<String> get instructions;
  bool get addingInstruction;
  bool get updatingInstructions;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectStateCopyWith<ProjectState> get copyWith =>
      _$ProjectStateCopyWithImpl<ProjectState>(
          this as ProjectState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectState &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.generationModel, generationModel) ||
                other.generationModel == generationModel) &&
            (identical(other.generating, generating) ||
                other.generating == generating) &&
            (identical(other.done, done) || other.done == done) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.videoResult, videoResult) ||
                other.videoResult == videoResult) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other.instructions, instructions) &&
            (identical(other.addingInstruction, addingInstruction) ||
                other.addingInstruction == addingInstruction) &&
            (identical(other.updatingInstructions, updatingInstructions) ||
                other.updatingInstructions == updatingInstructions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      generationModel,
      generating,
      done,
      result,
      videoResult,
      error,
      const DeepCollectionEquality().hash(instructions),
      addingInstruction,
      updatingInstructions);

  @override
  String toString() {
    return 'ProjectState(mode: $mode, generationModel: $generationModel, generating: $generating, done: $done, result: $result, videoResult: $videoResult, error: $error, instructions: $instructions, addingInstruction: $addingInstruction, updatingInstructions: $updatingInstructions)';
  }
}

abstract mixin class $ProjectStateCopyWith<$Res> {
  factory $ProjectStateCopyWith(
          ProjectState value, $Res Function(ProjectState) _then) =
      _$ProjectStateCopyWithImpl;
  @useResult
  $Res call(
      {GenerationMode mode,
      GenerationModel generationModel,
      bool generating,
      bool done,
      ImageResponseDto? result,
      VideoResponseDto? videoResult,
      String? error,
      List<String> instructions,
      bool addingInstruction,
      bool updatingInstructions});

  $ImageResponseDtoCopyWith<$Res>? get result;
  $VideoResponseDtoCopyWith<$Res>? get videoResult;
}

class _$ProjectStateCopyWithImpl<$Res> implements $ProjectStateCopyWith<$Res> {
  _$ProjectStateCopyWithImpl(this._self, this._then);

  final ProjectState _self;
  final $Res Function(ProjectState) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? generationModel = null,
    Object? generating = null,
    Object? done = null,
    Object? result = freezed,
    Object? videoResult = freezed,
    Object? error = freezed,
    Object? instructions = null,
    Object? addingInstruction = null,
    Object? updatingInstructions = null,
  }) {
    return _then(_self.copyWith(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as GenerationMode,
      generationModel: null == generationModel
          ? _self.generationModel
          : generationModel // ignore: cast_nullable_to_non_nullable
              as GenerationModel,
      generating: null == generating
          ? _self.generating
          : generating // ignore: cast_nullable_to_non_nullable
              as bool,
      done: null == done
          ? _self.done
          : done // ignore: cast_nullable_to_non_nullable
              as bool,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageResponseDto?,
      videoResult: freezed == videoResult
          ? _self.videoResult
          : videoResult // ignore: cast_nullable_to_non_nullable
              as VideoResponseDto?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: null == instructions
          ? _self.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addingInstruction: null == addingInstruction
          ? _self.addingInstruction
          : addingInstruction // ignore: cast_nullable_to_non_nullable
              as bool,
      updatingInstructions: null == updatingInstructions
          ? _self.updatingInstructions
          : updatingInstructions // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ImageResponseDtoCopyWith<$Res>? get result {
    if (_self.result == null) {
      return null;
    }

    return $ImageResponseDtoCopyWith<$Res>(_self.result!, (value) {
      return _then(_self.copyWith(result: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $VideoResponseDtoCopyWith<$Res>? get videoResult {
    if (_self.videoResult == null) {
      return null;
    }

    return $VideoResponseDtoCopyWith<$Res>(_self.videoResult!, (value) {
      return _then(_self.copyWith(videoResult: value));
    });
  }
}

extension ProjectStatePatterns on ProjectState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProjectState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProjectState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProjectState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProjectState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            GenerationMode mode,
            GenerationModel generationModel,
            bool generating,
            bool done,
            ImageResponseDto? result,
            VideoResponseDto? videoResult,
            String? error,
            List<String> instructions,
            bool addingInstruction,
            bool updatingInstructions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProjectState() when $default != null:
        return $default(
            _that.mode,
            _that.generationModel,
            _that.generating,
            _that.done,
            _that.result,
            _that.videoResult,
            _that.error,
            _that.instructions,
            _that.addingInstruction,
            _that.updatingInstructions);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            GenerationMode mode,
            GenerationModel generationModel,
            bool generating,
            bool done,
            ImageResponseDto? result,
            VideoResponseDto? videoResult,
            String? error,
            List<String> instructions,
            bool addingInstruction,
            bool updatingInstructions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectState():
        return $default(
            _that.mode,
            _that.generationModel,
            _that.generating,
            _that.done,
            _that.result,
            _that.videoResult,
            _that.error,
            _that.instructions,
            _that.addingInstruction,
            _that.updatingInstructions);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            GenerationMode mode,
            GenerationModel generationModel,
            bool generating,
            bool done,
            ImageResponseDto? result,
            VideoResponseDto? videoResult,
            String? error,
            List<String> instructions,
            bool addingInstruction,
            bool updatingInstructions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectState() when $default != null:
        return $default(
            _that.mode,
            _that.generationModel,
            _that.generating,
            _that.done,
            _that.result,
            _that.videoResult,
            _that.error,
            _that.instructions,
            _that.addingInstruction,
            _that.updatingInstructions);
      case _:
        return null;
    }
  }
}

class _ProjectState implements ProjectState {
  const _ProjectState(
      {this.mode = GenerationMode.splashArt,
      this.generationModel = GenerationModel.gpt,
      this.generating = false,
      this.done = false,
      this.result,
      this.videoResult,
      this.error,
      final List<String> instructions = const [],
      this.addingInstruction = false,
      this.updatingInstructions = false})
      : _instructions = instructions;

  @override
  @JsonKey()
  final GenerationMode mode;
  @override
  @JsonKey()
  final GenerationModel generationModel;
  @override
  @JsonKey()
  final bool generating;
  @override
  @JsonKey()
  final bool done;
  @override
  final ImageResponseDto? result;
  @override
  final VideoResponseDto? videoResult;
  @override
  final String? error;
  final List<String> _instructions;
  @override
  @JsonKey()
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  @override
  @JsonKey()
  final bool addingInstruction;
  @override
  @JsonKey()
  final bool updatingInstructions;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProjectStateCopyWith<_ProjectState> get copyWith =>
      __$ProjectStateCopyWithImpl<_ProjectState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProjectState &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.generationModel, generationModel) ||
                other.generationModel == generationModel) &&
            (identical(other.generating, generating) ||
                other.generating == generating) &&
            (identical(other.done, done) || other.done == done) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.videoResult, videoResult) ||
                other.videoResult == videoResult) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            (identical(other.addingInstruction, addingInstruction) ||
                other.addingInstruction == addingInstruction) &&
            (identical(other.updatingInstructions, updatingInstructions) ||
                other.updatingInstructions == updatingInstructions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      generationModel,
      generating,
      done,
      result,
      videoResult,
      error,
      const DeepCollectionEquality().hash(_instructions),
      addingInstruction,
      updatingInstructions);

  @override
  String toString() {
    return 'ProjectState(mode: $mode, generationModel: $generationModel, generating: $generating, done: $done, result: $result, videoResult: $videoResult, error: $error, instructions: $instructions, addingInstruction: $addingInstruction, updatingInstructions: $updatingInstructions)';
  }
}

abstract mixin class _$ProjectStateCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory _$ProjectStateCopyWith(
          _ProjectState value, $Res Function(_ProjectState) _then) =
      __$ProjectStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {GenerationMode mode,
      GenerationModel generationModel,
      bool generating,
      bool done,
      ImageResponseDto? result,
      VideoResponseDto? videoResult,
      String? error,
      List<String> instructions,
      bool addingInstruction,
      bool updatingInstructions});

  @override
  $ImageResponseDtoCopyWith<$Res>? get result;
  @override
  $VideoResponseDtoCopyWith<$Res>? get videoResult;
}

class __$ProjectStateCopyWithImpl<$Res>
    implements _$ProjectStateCopyWith<$Res> {
  __$ProjectStateCopyWithImpl(this._self, this._then);

  final _ProjectState _self;
  final $Res Function(_ProjectState) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mode = null,
    Object? generationModel = null,
    Object? generating = null,
    Object? done = null,
    Object? result = freezed,
    Object? videoResult = freezed,
    Object? error = freezed,
    Object? instructions = null,
    Object? addingInstruction = null,
    Object? updatingInstructions = null,
  }) {
    return _then(_ProjectState(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as GenerationMode,
      generationModel: null == generationModel
          ? _self.generationModel
          : generationModel // ignore: cast_nullable_to_non_nullable
              as GenerationModel,
      generating: null == generating
          ? _self.generating
          : generating // ignore: cast_nullable_to_non_nullable
              as bool,
      done: null == done
          ? _self.done
          : done // ignore: cast_nullable_to_non_nullable
              as bool,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageResponseDto?,
      videoResult: freezed == videoResult
          ? _self.videoResult
          : videoResult // ignore: cast_nullable_to_non_nullable
              as VideoResponseDto?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: null == instructions
          ? _self._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      addingInstruction: null == addingInstruction
          ? _self.addingInstruction
          : addingInstruction // ignore: cast_nullable_to_non_nullable
              as bool,
      updatingInstructions: null == updatingInstructions
          ? _self.updatingInstructions
          : updatingInstructions // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ImageResponseDtoCopyWith<$Res>? get result {
    if (_self.result == null) {
      return null;
    }

    return $ImageResponseDtoCopyWith<$Res>(_self.result!, (value) {
      return _then(_self.copyWith(result: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $VideoResponseDtoCopyWith<$Res>? get videoResult {
    if (_self.videoResult == null) {
      return null;
    }

    return $VideoResponseDtoCopyWith<$Res>(_self.videoResult!, (value) {
      return _then(_self.copyWith(videoResult: value));
    });
  }
}

// dart format on
