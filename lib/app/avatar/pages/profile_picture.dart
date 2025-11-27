import 'dart:convert';
import 'dart:io';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_event.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_state.dart';
import 'package:piapiri_v2/app/profile/widgets/profile_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ProfilePicture extends StatefulWidget {
  final double size;
  final bool showEditButton;
  const ProfilePicture({
    super.key,
    this.size = 80,
    this.showEditButton = true,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final AvatarBloc _avatarBloc = getIt<AvatarBloc>();
  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AvatarBloc, AvatarState>(
        bloc: _avatarBloc,
        builder: (context, state) {
          bool hasIcon = state.validateAvatarModel?.imageData?.image != null &&
              state.validateAvatarModel!.imageData!.image.isNotEmpty;
          return Stack(
            children: [
              Container(
                height: widget.size,
                width: widget.size,
                alignment: Alignment.center,
                padding: EdgeInsets.all(hasIcon ? 0 : Grid.xs),
                decoration: BoxDecoration(
                  color: hasIcon
                      ? context.pColorScheme.transparent
                      : context.pColorScheme.secondary.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
                child: hasIcon
                    ? ClipOval(
                        child: Image.memory(
                          base64.decode(state.validateAvatarModel!.imageData!.image),
                          fit: BoxFit.contain,
                        ),
                      )
                    : SvgPicture.asset(
                        ImagesPath.user,
                        width: 56,
                        height: 56,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
              if (widget.showEditButton)
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 24,
                      width: 24,
                      padding: const EdgeInsets.all(
                        Grid.xs + Grid.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: context.pColorScheme.card, // Arka plan rengi
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        ImagesPath.pencil,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    onTap: () {
                      PBottomSheet.show(context,
                          title: L10n.tr('profile_picture'),
                          child: Column(
                            children: [
                              ProfileRow(
                                iconName: ImagesPath.ai,
                                title: L10n.tr('create_ai_profile'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  router.push(const AiPhotoRoute());
                                },
                              ),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              const PDivider(),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              ProfileRow(
                                iconName: ImagesPath.galery,
                                title: L10n.tr('select_from_gallery'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              const PDivider(),
                              const SizedBox(
                                height: Grid.m,
                              ),
                              ProfileRow(
                                iconName: ImagesPath.photo,
                                title: L10n.tr('take_photo'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                            ],
                          ));
                    },
                  ),
                ),
            ],
          );
        });
  }

// Kullaniciya galeriden veya kameradan resim secme imkani sunan fonksiyon
  Future _pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: L10n.tr('edit_image'),
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: L10n.tr('edit_image'),
            aspectRatioLockEnabled: true,
            resetButtonHidden: true,
            minimumAspectRatio: 1.0,
            doneButtonTitle: L10n.tr('tamam'),
            cancelButtonTitle: L10n.tr('vazgec'),
          ),
        ],
      );
      if (croppedFile == null) return;
      final imageTemp = File(croppedFile.path);
      List<int> imageBytes = await imageTemp.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      _avatarBloc.add(
        UploadAvatarEvent(
          image: base64Image,
        ),
      );
      setState(() {});
    } on PlatformException catch (e) {
      LogUtils.pLog('Failed to pick image: $e');
      if (e.toString().contains('camera_access_denied')) {
        PBottomSheet.showError(
          NavigatorKeys.navigatorKey.currentContext ?? context,
          showFilledButton: true,
          content: L10n.tr('camera_access_denied'),
          filledButtonText: L10n.tr('go_to_settings'),
          onFilledButtonPressed: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
        );
      }
    }
  }
}
