from sqlalchemy import Column, Integer, Text

from sqlalchemy.ext.declarative import declarative_base


vv_class_reg = {}
VolunteerVencieBase = declarative_base(class_registry=vv_class_reg)


def classReprStr(class_name, *args):
    '''
        Format the string representation of a table entry.
    '''
    return "<{} ({})>".format(class_name,
                              ", ".join(["'{}'".format(x) \
                                         for x in args]))


class VolunteerVeniceSchema(object):
    # SQLite does not support schemas.
    #__table_args__ = {'schema': 'volunteer_venice'}
    pass


class Organization(VolunteerVeniceSchema, VolunteerVencieBase):
    __tablename__ = 'orgs'

    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)
    website = Column(Text)
    address = Column(Text)
    description = Column(Text)
    category = Column(Integer)
    phone_number = Column(Text)
    email = Column(Text)
    picture_location = Column(Text)
    video_location = Column(Text)

    def __repr__(self):
        return classReprStr("Org",
                            self.id,
                            self.name,
                            self.website,
                            self.address,
                            self.description,
                            self.category,
                            self.phone_number,
                            self.email,
                            self.picture_location,
                            self.video_location)


class Category(VolunteerVeniceSchema, VolunteerVencieBase):
    __tablename__ = 'category'

    id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False)

    def __repr__(self):
        return classReprStr("Category",
                            self.id,
                            self.name)
